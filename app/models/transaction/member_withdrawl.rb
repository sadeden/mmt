# frozen_string_literal: true

module Transaction
  class MemberWithdrawl < Transaction::Base

    validates :source,
              :source_coin,
              :source_quantity,
              :destination,
              :destination_coin,
              presence: true

    validates :source_quantity,
              numericality: { greater_than: 0 }

    validates :destination_quantity,
              :source_rate,
              :destination_rate,
              absence: true

    before_create :publish_to_source, :publish_to_destination

    private

    def publish_to_source
      # Debit source (member) liability with source_coin
      raise ActiveRecord::Rollback unless source.publish!(
        coin: source_coin,
        liability: -source_quantity,
        rate: nil,
        transaction_id: self
      )
    end

    def publish_to_destination
      # Credit destination (coin) assets by 0
      raise ActiveRecord::Rollback unless destination.publish!(
        assets: 0,
        transaction_id: self
      )
    end
  end
end
