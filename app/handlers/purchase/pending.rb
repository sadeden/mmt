module Handlers
  module Purchase
    class Pending
      include Command::Handler

      def call(command)
        with_aggregate(Domain::Purchase, command.aggregate_id, { state: command.state }) do |purchase|
          purchase.pending!
        end
      end
    end
  end
end
