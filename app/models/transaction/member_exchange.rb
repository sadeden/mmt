# frozen_string_literal: true

module Transaction
  class MemberExchange < Transaction::Base

    validates :source,
              :source_coin,
              :source_rate,
              :source_quantity,
              :destination,
              :destination_coin,
              :destination_rate,
              :destination_quantity,
              presence: true

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validate :values_match, :rates_match

    before_save :publish_to_source,
                :publish_to_destination,
                :publish_to_source_coin,
                :publish_to_destination_coin

    private

    def publish_to_source
      # Debit source (member) liability of source_coin
      raise ActiveRecord::Rollback unless source.publish!(
        coin: source_coin,
        liability: -source_quantity,
        rate: source_rate,
        transaction_id: self
      )
    end

    def publish_to_destination
      # Credit destination (member) liability of destination_coin
      raise ActiveRecord::Rollback unless destination.publish!(
        coin: destination_coin,
        liability: destination_quantity,
        rate: destination_rate,
        transaction_id: self
      )
    end

    def publish_to_source_coin
      raise ActiveRecord::Rollback unless source_coin.publish!(
        assets: source_quantity,
        transaction_id: self
      )
    end

    def publish_to_destination_coin
      raise ActiveRecord::Rollback unless destination_coin.publish!(
        assets: -destination_quantity,
        transaction_id: self
      )
    end
  end
end
