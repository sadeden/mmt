# frozen_string_literal: true

module Admins
  class CoinsController < AdminsController
    before_action :find_coin, only: [:edit, :load, :history]
    before_action :load_coin, only: [:load]

    def index
      @coins = Coin.all
    end

    def edit
    end

    def load
      if @load_coin.success?
        redirect_to admins_coins_path, notice: @load_coin.notice
      else
        redirect_to admins_coins_path, error: @load_coin.error
      end
    end

    def history
      @events = @coin.history
    end

    private

    def find_coin
      @coin ||= Coin.friendly.find(params[:id]).decorate
    end

    def load_coin
      @load_coin = LoadCoin.call(load_params: load_params.merge(
        coin_id: @coin.id,
        member_id: current_member.id
      ))
    end

    def load_params
      params.require(:coin).permit(:quantity, :rate)
    end

    def coin_params
      params.require(:coin).permit(:name, :central_reserve_in_sub_units)
    end
  end
end
