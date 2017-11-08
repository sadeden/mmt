# frozen_string_literal: true

module Handlers
  module Member
    class Allocate
      include Command::Handler

      def call(service)
        with_aggregate(Domain::Member, service.aggregate_id, attributes(service)) do |member|
          member.allocate!
        end
      end

      private

      def attributes(service)
        {
          coin_id: service.coin_id,
          quantity: service.quantity,
          rate: service.rate,
        }
      end
    end
  end
end
