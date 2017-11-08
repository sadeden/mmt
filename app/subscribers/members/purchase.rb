# frozen_string_literal: true

module Subscribers
  module Members
    class Purchase < Subscribers::Base

      def call(event)
        execute Command::Member::Deallocate.new(deallocation_attributes(event))
        execute Command::Coin::Allocate.new(deallocation_attributes(event))
        execute Command::Coin::Deallocate.new(allocation_attributes(event))
        execute Command::Member::Allocate.new(allocation_attributes(event))
      end

      private

      def deallocation_attributes(event)
        {
          coin_id: event.data.fetch(:source_coin_id),
          rate: event.data.fetch(:source_rate),
          quantity: event.data.fetch(:source_quantity).to_d / 10**event.data.fetch(:source_subdivision),
          member_id: event.data.fetch(:member_id)
        }
      end

      def allocation_attributes(event)
        {
          coin_id: event.data.fetch(:destination_coin_id),
          rate: event.data.fetch(:destination_rate),
          quantity: event.data.fetch(:destination_quantity).to_d / 10**event.data.fetch(:destination_subdivision),
          member_id: event.data.fetch(:member_id)
        }
      end

    end
  end
end
