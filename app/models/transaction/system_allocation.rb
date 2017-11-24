# frozen_string_literal: true

module Transaction
  class SystemAllocation < Transaction::Base

    validates :source,
              :source_coin,
              :destination,
              :destination_coin,
              :destination_rate,
              :destination_quantity,
              presence: true

    validates :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validates :source_quantity,
              :source_rate,
              absence: true

    before_create :publish_to_source, :publish_to_destination

    private

    def publish_to_source
      # Debit source (coin) assets
      raise ActiveRecord::Rollback unless source.publish!(
        assets: -destination_quantity,
        transaction_id: self
      )
    end

    def publish_to_destination
      # Credit destination (member) liability with destination_coin (same as source)
      raise ActiveRecord::Rollback unless destination.publish!(
        coin: source_coin,
        liability: destination_quantity,
        rate: destination_rate,
        transaction_id: self
      )
    end
  end
end
