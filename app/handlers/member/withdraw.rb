# frozen_string_literal: true

module Handlers
  module Member
    class Withdraw
      include Command::Handler

      def call(command)
        with_aggregate(Domain::Member, command.aggregate_id, attributes(command)) do |member|
          member.withdraw!
        end
      end

      private

      def attributes(command)
        {
          coin_id: command.coin_id,
          quantity: command.quantity,
        }
      end
    end
  end
end
