module Subscribers
  module Members
    class Withdrawl < Subscribers::Base

      def call(event)
        execute Command::Members::Deallocation.new(withdrawl_attributes)
      end

      private

      def withdrawl_attributes
        {
          coin_id: event.data.fetch(:coin_id),
          rate: event.data.fetch(:rate),
          quantity: event.data.fetch(:quantity).to_d / 10**event.data.fetch(:subdivision),
          member_id: event.data.fetch(:member_id)
        }
      end

    end
  end
end
