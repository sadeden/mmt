# frozen_string_literal: true

module Handlers
  module Member
    class Purchase
      include Command::Handler

      def call(service)
        with_aggregate(Domain::Member, service.aggregate_id, attributes(service)) do |member|
          member.purchase!
        end
      end

      private

      def attributes(service)
        {
          source_coin_id: service.source_coin_id,
          source_rate: service.source_rate,
          source_quantity: service.source_quantity,
          destination_coin_id: service.destination_coin_id,
          destination_rate: service.destination_rate,
          destination_quantity: service.destination_quantity,
          member_id: service.member_id
        }
      end
    end
  end
end
