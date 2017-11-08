# frozen_string_literal: true

module Handlers
  module Purchase
    class Cancel
      include Command::Handler

      def call(command)
        with_aggregate(Domain::Purchase, command.aggregate_id, { state: command.state }) do |purchase|
          purchase.cancel!
        end
      end

    end
  end
end
