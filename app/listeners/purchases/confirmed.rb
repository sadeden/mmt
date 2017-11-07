# frozen_string_literal: true

module Listeners
  module Purchases
    class Confirmed < Listeners::Base

      def call(event)
        ActiveRecord::Base.transaction do
          purchase_order = ::PurchaseOrder.find(event.data[:purchase_order_id])
          execute Services::Member::Deallocate.new(deallocation_attributes(purchase_order))
          execute Services::Coin::Allocate.new(deallocation_attributes(purchase_order))
          execute Services::Coin::Deallocate.new(allocation_attributes(purchase_order))
          execute Services::Member::Allocate.new(allocation_attributes(purchase_order))
          purchase_order.complete!
        end
      end

      private

      def deallocation_attributes(purchase_order)
        {
          coin_id: purchase_order.source_coin_id,
          rate: purchase_order.source_rate,
          quantity: purchase_order.source_quantity.to_d / 10**purchase_order.source_coin.subdivision,
          member_id: purchase_order.member_id
        }
      end

      def allocation_attributes(purchase_order)
        {
          coin_id: purchase_order.destination_coin_id,
          rate: purchase_order.destination_rate,
          quantity: purchase_order.destination_quantity.to_d / 10**purchase_order.destination_coin.subdivision,
          member_id: purchase_order.member_id
        }
      end

    end
  end
end
