# frozen_string_literal: true

module Services
  module Member
    class Deallocate < Services::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :rate

      validates :member_id, :coin_id,
                :quantity, :rate,
                presence: true

      validates :rate, :quantity,
                numericality: { greater_than: 0 }

      alias :aggregate_id :member_id

      def handler_class
        Handlers::Member::Deallocate
      end

      def ensure_less_than_balance
        coin = ::Coin.find coin_id
        member = ::Member.find member_id
        return if coin && coin.store_as_integer(quantity) < member.coin_balance(coin_id)
        errors.add :quantity, "Must be less than #{central_reserve}"
      end
    end
  end
end
