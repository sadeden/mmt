# frozen_string_literal: true

module Services
  module Member
    class Purchase < Services::Base
      attr_accessor :source_coin_id,
                    :source_rate,
                    :source_quantity,
                    :destination_coin_id,
                    :destination_rate,
                    :destination_quantity,
                    :member_id

      validates :member_id, :source_coin_id, :source_rate, :source_quantity,
                :destination_coin_id, :destination_rate, :destination_quantity,
                presence: true

      validates :source_quantity, :source_rate,
                :destination_quantity, :destination_rate,
                numericality: { greater_than: 0 }

      validate :current_source_coin_balance

      validate :values_square

      validate :ensure_less_than_central_reserve

      alias :aggregate_id :member_id

      def handler_class
        Handlers::Member::Purchase
      end

      private

      def source_coin
        @source_coin ||= ::Coin.find(source_coin_id)
      end

      def destination_coin
        @destination_coin ||= ::Coin.find(destination_coin_id)
      end

      def member
        @member ||= ::Member.find member_id
      end

      def current_source_coin_balance
        source_coin_balance = member.coin_balance(source_coin_id)
        return unless source_coin_balance < source_quantity.to_d
        self.errors.add :balance, "Insufficient funds to complete this purchase"
      end

      def rates_match
        source_rate_matches = BigDecimal.new(source_rate) == source_coin.btc_rate
        destination_rate_matches = BigDecimal.new(destination_rate) == destination_coin.btc_rate
        return unless source_rate_matches && destination_rate_matches
        self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
      end

      def values_square
        source_value = source_coin.store_as_integer(source_quantity) * source_rate.to_d
        destination_value = destination_coin.store_as_integer(destination_quantity) * destination_rate.to_d
        return if (source_value - destination_value).zero?
        self.errors.add :values_square, "Invalid purchase"
      end

      def ensure_less_than_central_reserve
        destination_coin = ::Coin.find_by(id: destination_coin_id)
        central_reserve_value = destination_coin.central_reserve
        return if destination_coin && BigDecimal.new(destination_quantity) < central_reserve_value
        self.errors.add :destination_quantity, "Invalid purchase"
      end
    end
  end
end
