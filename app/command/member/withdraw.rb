# frozen_string_literal: true

module Command
  module Member
    class Withdraw < Command::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,

      validates :coin_id,
                :member_id,
                :quantity,
                presence: true

      validates :quantity, numericality: { greater_than: 0 }

      validate :less_than_central_reserve

      alias :aggregate_id :member_id

      private

      def ensure_less_than_balance
        coin = ::Coin.find coin_id
        member = ::Member.find member_id
        balance = member.coin_balance(coin_id)
        return if coin && coin.store_as_integer(quantity) < balance
        errors.add :quantity, "Your current balance is too low to withdraw #{quantity}"
      end
    end
  end
end
