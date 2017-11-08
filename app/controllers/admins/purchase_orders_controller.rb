# frozen_string_literal: true

module Admins
  class PurchaseOrdersController < AdminsController
    before_action :find_purchase_order, only: [:cancel, :confirm, :in_progress]

    def index
      @purchase_orders = PurchaseOrder.all
    end

    def show
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    def cancel
      if cancel_purchase.success?
        redirect_to admins_purchase_orders_path, notice: "Purchase order cancelled "
      else
        redirect_to admins_purchase_orders_path, notice: "Failed to cancel purchase order"
      end
    end

    def confirm
      if @purchase_order.confirm!
        redirect_to admins_purchase_orders_path, notice: "Purchase order confirmed"
      else
        redirect_to admins_purchase_orders_path, notice: "Failed to confirm purchase order"
      end
    end

    def in_progress
      if @purchase_order.in_progress!
        redirect_to admins_purchase_orders_path, notice: "Purchase order in progress"
      else
        redirect_to admins_purchase_orders_path, notice: "Failed to mark purchase order as in progress"
      end
    end

    private

    def find_purchase_order
      @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    end

    def cancel_purchase
      @cancel_purchase ||= CancelPurchase.call(cancellation_params: {
        state: :cancelled,
        purchase_order_id: @purchase_order.id
      })
    end
  end
end
