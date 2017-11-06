# frozen_string_literal: true

module Handlers
  module Coin
    class Load
      include Services::Handler

      def call(service)
        with_aggregate(Domain::Coin, service.aggregate_id, attributes(service)) do |coin|
          coin.load!
        end
      end

      private

      def attributes(service)
        {
          coin_id: service.coin_id,
          member_id: service.member_id,
          quantity: service.quantity,
          rate: service.rate
        }
      end
    end
  end
end
