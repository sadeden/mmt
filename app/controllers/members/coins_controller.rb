# frozen_string_literal: true

module Members
  class CoinsController < ApplicationController
    before_action :find_coin, only: [:show]

    def index
      @crypto = Coin.crypto_with_balance(current_member)
      @fiat = Coin.fiat_with_balance(current_member)
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: { coin: @coin, btc_rate: @coin.btc_rate } }
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:id]).decorate
    end
  end
end
