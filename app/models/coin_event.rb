# frozen_string_literal: true

class CoinEvent < ApplicationRecord
  include EventHelper

  belongs_to :coin
  belongs_to :triggered_by, class_name: 'Transaction::Base',
                            foreign_key: :transaction_id,
                            inverse_of: :coin_events

  def readonly?
    Rails.env.development? ? false : !new_record?
  end

  validates :assets,
            :triggered_by,
            presence: true

  validates :assets, numericality: { only_integer: true }

  validate :coin_assets, unless: :deposit?

  private

  def coin_assets
    return true if exchange? && triggered_by.destination_coin != coin
    return true if assets.abs < coin.assets
    self.errors.add :assets, "Insufficient assets"
  end
end
