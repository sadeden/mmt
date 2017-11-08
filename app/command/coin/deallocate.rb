# frozen_string_literal: true

module Command
  module Coin
    class Deallocate < Command::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :rate

      validates :member_id,
                :coin_id,
                :quantity,
                :rate,
                presence: true

      validates :rate,
                :quantity,
                numericality: { greater_than: 0 }

      validate :ensure_less_than_central_reserve

      alias :aggregate_id :coin_id

      private

      def ensure_less_than_central_reserve
        coin = ::Coin.find coin_id
        central_reserve = coin.central_reserve
        return if coin && coin.store_as_integer(quantity) < central_reserve
        errors.add :quantity, "Must be less than #{central_reserve} #{central_reserve / 10**coin.subdivision}"
      end
    end
  end
end

