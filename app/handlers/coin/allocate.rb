# frozen_string_literal: true

module Handlers
  module Coin
    class Allocate
      include Services::Handler

      def call(service)
        with_aggregate(Domain::Coin, service.aggregate_id, attributes(service)) do |coin|
          coin.allocate!
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