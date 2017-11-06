# frozen_string_literal: true

module Handlers
  module Member
    class Withdraw
      include Services::Handler

      def call(transaction)
        with_aggregate(Domain::Member, transaction.aggregate_id, attributes(transaction)) do |member|
          member.assign!
        end
      end

      private

      def attributes(transaction)
        {
          coin_id: transaction.coin_id,
          member_id: transaction.member_id,
          quantity: transaction.quantity,
          rate: transaction.initial_btc_rate
        }
      end
    end
  end
end
