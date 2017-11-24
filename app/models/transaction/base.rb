# frozen_string_literal: true

module Transaction
  class Base < ApplicationRecord

    self.table_name = :transactions

    ################# RULES OF TRANSACTION ##################
    #                                                       #
    #  The sum of all entries on the asset side must equal  #
    #    the sum of all entries on the liabilities side     #
    #                                                       #
    #             Source is ALWAYS a debit                  #
    #          Destination is ALWAYS a credit               #
    #      Each transaction must have 2 event entries       #
    #                                                       #
    #########################################################

    belongs_to :previous_transaction, class_name: 'Transaction::Base', foreign_key: :previous_transaction_id

    belongs_to :source, polymorphic: true
    belongs_to :destination, polymorphic: true

    belongs_to :source_coin, class_name: 'Coin', foreign_key: :source_coin_id
    belongs_to :destination_coin, class_name: 'Coin', foreign_key: :destination_coin_id

    belongs_to :initiated_by, class_name: 'Member', foreign_key: :initiated_by_id, inverse_of: :initiated_transactions
    belongs_to :authorized_by, class_name: 'Member', foreign_key: :authorized_by_id, inverse_of: :authorized_transactions

    has_many :coin_events, foreign_key: :transaction_id, inverse_of: :triggered_by
    has_many :member_coin_events, foreign_key: :transaction_id, inverse_of: :triggered_by

    def readonly?
      Rails.env.development? ? false : !new_record?
    end

    TYPES = %w[
      SystemDeposit SystemAllocation SystemWithdrawl
      MemberDeposit MemberAllocation MemberExchange MemberWithdrawl
    ].freeze

    TYPES.each do |type|
      scope type.underscore.to_sym, -> { where type: "#{parent}::#{type}" }

      define_method "#{type.underscore}?" do
        type == self.type.demodulize
      end
    end

    validates :type, presence: true, inclusion: { in: TYPES.map{ |type| "#{parent}::#{type}" } }

    validates :source, :destination, :initiated_by, presence: true

    validates :previous_transaction, presence: true, unless: :original_transaction

    private

    def rates_match
      source_rate_matches = source_rate.to_d == source_coin.btc_rate
      destination_rate_matches = destination_rate.to_d == destination_coin.btc_rate
      return true if source_rate_matches && destination_rate_matches
      self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
    end

    def values_match
      source_value = ((source_quantity * source_rate).round(Coin::BTC_SUBDIVISION) * 10**(Coin::BTC_SUBDIVISION - source_coin.subdivision)).to_i
      destination_value = ((destination_quantity * destination_rate).round(Coin::BTC_SUBDIVISION) * 10**(Coin::BTC_SUBDIVISION - destination_coin.subdivision)).to_i
      return true if (source_value - destination_value).zero?
      self.errors.add :values_match, "Invalid purchase"
    end

    def original_transaction
      unless persisted?
        last_transaction = self.class.order('created_at DESC').find_by(source_id: source_id, destination_id: destination_id)
        last_transaction.blank? ? true : (last_transaction.id == source_id)
      end
    end
  end
end
