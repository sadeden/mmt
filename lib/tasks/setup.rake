# frozen_string_literal: true

namespace :setup do
  task portfolios: :environment do
    member = Member.find_or_initialize_by(email: "someone@example.com") do |usr|
      usr.update!(admin: true, password: "password")
    end

    btc = Coin.find_by(code: "BTC")
    eth = Coin.find_by(code: "ETH")
    Portfolio.create!(
      member: member,
      holdings_attributes: [
        { coin_id: btc.id, quantity: 1.2 },
        { coin_id: eth.id, quantity: 2.1 },
      ]
    )
  end

  task coins: :environment do
    Coin.find_or_initialize_by(
      code: "BTC"
    ).update!(
      name: "Bitcoin",
      central_reserve_in_sub_units: 1_000_000_000_000
    )

    Coin.find_or_initialize_by(
      code: "NEO"
    ).update!(
      name: "Neo/Ant",
      central_reserve_in_sub_units: 1_000_000_000_000_000
    )

    Coin.find_or_initialize_by(
      code: "ETH"
    ).update!(
      name: "Ethereum",
      central_reserve_in_sub_units: 1_000_000_000_000
    )

    Coin.find_or_initialize_by(
      code: "GBP"
    ).update!(
      name: "Sterling",
      central_reserve_in_sub_units: 1_000,
      crypto_currency: false,
      subdivision: 2
    )

    Coin.find_or_initialize_by(
      code: "USD"
    ).update!(
      name: "United States Dollar",
      central_reserve_in_sub_units: 1_000,
      crypto_currency: false,
      subdivision: 2
    )
  end

  task import: :coins do
    path = Rails.root.join(*%w[db seed crypto.csv])
    coins = Coin.all.to_a.index_by(&:code)

    Portfolio.transaction do
      CSV.foreach(path, headers: true) do |row|
        user = User.find_or_create_by!(email: row["email"].strip.downcase) do |usr|
          usr.password = SecureRandom.hex
        end

        previous_portfolio = user.live_portfolio || user.portfolios.build

        previous_holdings = previous_portfolio.holdings.includes(:coin).to_a

        next_portfolio = user.portfolios.build(
          created_at: Date.parse(row["date"])
        )

        %w[BTC ETH NEO].each do |code|
          quantity = previous_holdings.find { |h| h.coin.code == code }&.quantity.to_i +
            row[code].to_i * 10**(coins[code].subdivision)

          next_portfolio.holdings.build(coin: coins[code], quantity: quantity) unless quantity.zero?
        end

        previous_portfolio.next_portfolio = next_portfolio
      end
    end
  end
end
