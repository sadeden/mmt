# frozen_string_literal: true

module Transaction
  class SystemDeposit < Transaction::Base

    validates :destination,
              :destination_coin,
              :destination_rate,
              :destination_quantity,
              :source,
              :source_coin,
              presence: true

    validates :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validates :source_rate,
              :source_quantity,
              absence: true

    before_create :publish_to_destination #, :publish_to_admin

    private

    # def publish_to_admin
    #   # %%TODO%% To be moved into a separate events table admin_coin_events
    #   # Debit the source (admin member) liability
    #   raise ActiveRecord::Rollback unless source.publish!(
    #     coin: destination,
    #     liability: 0,
    #     admin_liability: -destination_quantity,
    #     rate: nil,
    #     transaction_id: self
    #   )
    # end

    def publish_to_destination
      # Credit the destination (coin) assets
      raise ActiveRecord::Rollback unless destination.publish!(
        assets: destination_quantity,
        transaction_id: self
      )
    end

  end
end
