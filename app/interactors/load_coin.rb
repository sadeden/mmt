# frozen_string_literal: true

class LoadCoin
  include Services::Execute
  include Interactor

  def call
    execute service
    context.message = "Successfully loaded coin"
  rescue Services::ValidationError => error
    Rails.logger.error "\n\n#{error.messages}\n\n#{error.backtrace}\n\n"
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end

  private

  def service
    Services::Coin::Allocate.new(load_params)
  end

  def load_params
    context.load_params
  end
end
