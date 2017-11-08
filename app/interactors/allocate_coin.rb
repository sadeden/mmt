# frozen_string_literal: true

class AllocateCoin
  include Command::Execute
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      execute Command::Coin::Deallocate.new(context.allocation_params)
      execute Command::Member::Allocate.new(context.allocation_params)
    end
    context.message = "Successfully allocated"
  rescue Command::ValidationError => error
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end

end

