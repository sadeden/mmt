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
    Services::Coin::Allocate.new(load_params)
  end

  def load_params
    context.load_params
  end
end
