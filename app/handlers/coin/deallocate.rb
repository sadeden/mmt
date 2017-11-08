# frozen_string_literal: true

module Handlers
  module Coin
    class Deallocate
      include Command::Handler

      def call(command)
        with_aggregate(Domain::Coin, command.aggregate_id, attributes(command)) do |coin|
          coin.deallocate!
        end
      end

      private

      def attributes(command)
        {
          member_id: command.coin_id,
          quantity: command.quantity,
          rate: command.rate,
        }
      end
    end
  end
end
