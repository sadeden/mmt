module Services
  module Member
    class Withdraw < Services::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :initial_btc_rate

      validates :coin_id,
                :member_id,
                :quantity,
                :initial_btc_rate,
                presence: true

      validate :less_than_central_reserve

      alias :aggregate_id :member_id

      private

      def ensure_less_than_central_reserve
        coin = ::Coin.find_by id: coin_id
        return if coin && destination_quantity < coin.max_buyable_quantity
        errors.add :destination_quantity, "must be less than #{coin.max_buyable_quantity}"
      end
    end
  end
end
