# frozen_string_literal: true

class Handlers
  module Coin
    class Allocate
      include Command::Handler

      def call(command)
        with_aggregate(Domain::Coin, command.aggregate_id, attributes(command)) do |coin|
          coin.allocate!
        end
      end

      private

      def attributes(command)
        {
          member_id: command.member_id,
          quantity: command.quantity,
          rate: command.rate,
        }
      end
    end
  end
end
