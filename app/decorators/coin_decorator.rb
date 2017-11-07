# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def header
    "#{name} (#{code})"
  end

  def balance
    h.current_member.coin_balance(id) / 10**subdivision
  end

  def central_reserve_balance
    h.number_to_currency(central_reserve.to_d / 10**subdivision, precision: subdivision, unit: '')
  end
end
