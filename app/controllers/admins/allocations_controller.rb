# frozen_string_literal: true

module Admins
  class AllocationsController < AdminsController
    before_action :find_coin
    before_action :allocate_coin, only: [:create]

    def new
    end

    def create
      if @allocation.success?
        redirect_to admins_coins_path, notice: @allocation.message
      else
        redirect_to new_admins_coin_allocation_path(@coin.id), notice: @allocation.message
      end
    end


    private

    def allocate_coin
      @allocation = AllocateCoin.call(allocation_params: allocation_params.merge(coin_id: @coin.id))
    end

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def allocation_params
      params.require(:allocation).permit(:member_id, :quantity, :rate)
    end
  end
end
