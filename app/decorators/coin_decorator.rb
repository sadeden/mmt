# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def balance
    h.current_member.coin_balance(id) / 10**subdivision
  end
end
