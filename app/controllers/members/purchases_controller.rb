# frozen_string_literal: true

module Members
  class PurchasesController < ApplicationController
    before_action :find_coin, only: [:new, :create]
    before_action :create_purchase, only: [:create]

    def index
    end

    def new
    end

    def create
      if @purchase.success?
        redirect_to purchases_path(@coin), notice: @purchase.message
      else
        redirect_to new_purchase_path(@coin), alert: @purchase.message
      end
    end

    private

    def create_purchase
      @purchase = CreatePurchase.call(
        member_id: current_member.id,
        purchase_params: purchase_params.merge(destination_coin_id: @coin.id)
      )
    end

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def purchase_params
      params.require(:purchase).permit(
        :source_quantity,
        :source_rate,
        :source_coin_id,
        :destination_rate,
        :destination_quantity,
      )
    end
  end
end
