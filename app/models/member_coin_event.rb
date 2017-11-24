# frozen_string_literal: true

class MemberCoinEvent < ApplicationRecord
  include EventHelper

  belongs_to :coin
  belongs_to :member
  belongs_to :triggered_by, class_name: 'Transaction::Base', foreign_key: :transaction_id, inverse_of: :member_coin_events

  scope :with_coin, ->(coin_id) { where coin_id: coin_id }
  scope :with_coins, -> { joins(:coin) }
  scope :crypto, -> { with_coins.merge(Coin.crypto) }
  scope :fiat, -> { with_coins.merge(Coin.fiat) }

  def readonly?
    Rails.env.development? ? false : !new_record?
  end

  validates :liability,
            :triggered_by,
            presence: true

  validates :liability, numericality: { only_integer: true }

  validate :member_coin_liability, unless: :allocation?

  private

  def member_coin_liability
    return true if exchange? && triggered_by.source_coin != coin
    return true if liability.abs < member.liability(coin.id)
    self.errors.add :liability, "Insufficient funds"
  end
end
