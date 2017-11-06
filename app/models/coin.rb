# frozen_string_literal: true

class Coin < ApplicationRecord
  extend FriendlyId
  friendly_id :code, use: :slugged

  scope :ordered, -> { order(:code) }
  scope :crypto, -> { where(crypto_currency: true) }
  scope :not_self, ->(coin_id) { where.not(id: coin_id) }

  attr_readonly :code, :subdivision

  validates :subdivision, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }

  validates :code, uniqueness: { case_sensitive: true },
                   format: { with: /\A[a-zA-Z0-9_\.]*\z/ },
                   exclusion: { in: MagicMoneyTree::InaccessibleWords.all },
                   presence: true

  def stream_name
    "Domain::Coin$#{id}"
  end

  def central_reserve
    RailsEventStore::Projection.from_stream(stream_name).init( -> { { total: BigDecimal.new(0) } })
      .when(Events::Coin::Loaded, increment)
      .when(Events::Coin::Allocation, increment)
      .when(Events::Coin::Deallocation, decrement)
      .run(Rails.application.config.event_store)[:total]
  end

  def increment
    ->(state, event) { state[:total] += event.data[:quantity] }
  end

  def decrement
    ->(state, event) { state[:total] -= event.data[:quantity] }
  end

  def history
    Rails.application.config.event_store.read_stream_events_forward("Domain::Coin$#{id}")
  end

  def store_as_integer(quantity)
    (BigDecimal.new(quantity) * (10 ** subdivision)).to_i
  end

  def read_as_decimal(quantity)
    quantity.to_d / (10 ** subdivision)
  end

  def value(iso_currency)
    btc_rate * 1.0 / fiat_btc_rate(iso_currency)
  end

  # @return The amount of this currency that buys one BTC
  def btc_rate
    crypto_currency ? crypto_btc_rate : fiat_btc_rate
  end

  # def central_reserve
  #   BigDecimal.new(central_reserve_in_sub_units) / 10**subdivision
  # end

  # @return <Integer> The value of the live assets
  # def live_assets_quantity
  #   live_assets.sum(:quantity) || 0
  # end

  # def live_assets_quantity_display
  #   live_assets_quantity / 10**subdivision
  # end

  # def max_buyable_quantity
  #   central_reserve_in_sub_units - live_assets_quantity
  # end

  private

  def fiat_btc_rate(iso_currency = nil)
    1.0 / BigDecimal.new(
      coinbase_rates["data"]["rates"][iso_currency || code]
    )
  end

  def coinbase_rates
    Rails.cache.fetch("coinbase_rates", expires_in: 30.minutes, race_condition_ttl: 5.seconds) do
      HTTParty.get("https://api.coinbase.com/v2/exchange-rates?currency=BTC").parsed_response
    end
  end

  def bittrex_rates
    Rails.cache.fetch("bittrex_rates", expires_in: 30.minutes, race_condition_ttl: 5.seconds) do
      HTTParty.get("https://bittrex.com/api/v1.1/public/getmarketsummaries").parsed_response
    end
  end

  def crypto_btc_rate
    return 1.0 if code == "BTC"
    # %%TODO%% We need a way to deal with missing codes so it doesn't cascade through and break the system
    # raise BittrexError, "Bittrex does not supply rates for #{code}" unless coins_by_bittrex.include? code
    bittrex_rates["result"].compact.find do |market|
      market["MarketName"] == "BTC-#{code}"
    end["Bid"]
  end

  def coins_by_bittrex
    bittrex_rates["result"].compact.map do |market|
      market["MarketName"].split('-').last
    end
  end

  def ensure_subdivision_multiple_of_ten
    return unless subdivision
    return unless (subdivision % 10).zero?
    errors.add :subdivision, "must be a multiple of 10"
  end
end
