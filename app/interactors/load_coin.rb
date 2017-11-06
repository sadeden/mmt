# frozen_string_literal: true

class LoadCoin
  include Services::Execute
  include Interactor

  def call
    execute service
    context.message = "Successfully loaded coin"
  rescue Services::ValidationError => e
    Rails.logger.error "\n\n#{e.message}\n\n#{e.backtrace}\n\n"
    context.fail!(message: "Failed to load coin: #{e.message}")
  end

  private

  def service
    Services::Coin::Load.new(
      rate: rate,
      quantity: quantity,
      coin_id: coin_id,
      member_id: member_id,
    )
  end

  def rate
    load_params[:rate]
  end

  def quantity
    load_params[:quantity]
  end

  def load_params
    context.load_params
  end

  def member_id
    context.member_id
  end

  def coin_id
    context.coin_id
  end
end
