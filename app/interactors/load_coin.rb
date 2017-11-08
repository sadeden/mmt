# frozen_string_literal: true

class LoadCoin
  include Command::Execute
  include Interactor

  def call
    execute Command::Coin::Allocate.new(context.load_params)
    context.message = "Successfully loaded coin"
  rescue Command::ValidationError => error
    Rails.logger.error "\n\n#{error.messages}\n\n#{error.backtrace}\n\n"
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end
end
