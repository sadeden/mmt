# frozen_string_literal: true

module Members
  class WithdrawlsController < ApplicationController
    before_action :find_coin, only: [:new, :create]
    before_action :withdraw_coin, only: [:create]

    def index
      @withdrawls = current_member.withdrawl_history
    end

    def new
    end

    def create
      if @withdraw_coin.success?
        redirect_to withdrawls_path, notice: @withdraw_coin.message
      else
        redirect_to new_withdrawl_path, alert: @withdraw_coin.message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def withdraw_coin
      @withdraw_coin = WithdrawCoin.call(withdrawl_params.merge(
        member_id: current_member.id,
        coin_id: @coin.id
      ))
    end

    def withdrawl_params
      params.require(:withdrawl).permit(:quantity)
    end
  end
end
