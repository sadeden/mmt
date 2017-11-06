# frozen_string_literal: true

class AllocateCoin
  include Services::Execute
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      execute Services::Coin::Deallocate.new(context.allocation_params)
      execute Services::Member::Allocate.new(context.allocation_params)
    end
    context.message = "Successfully allocated"
  rescue Services::ValidationError => error
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end
end

