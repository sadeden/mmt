# frozen_string_literal: true

class CancelPurchase
  include Command::Execute
  include Interactor

  def call
    execute Command::Purchase::Cancel.new(context.cancellation_params)
    context.success = "Successfully cancelled order"
  rescue Command::ValidationError => error
    context.fail!(message: "Failed to cancel order")
  rescue Domain::Purchase::AlreadyInProgress => error
    context.fail!(message: "Already in progress. Cannot cancel")
  rescue Domain::Purchase::AlreadyConfirmed => error
    context.fail!(message: "Already confirmed")
  rescue Domain::Purchase::AlreadyCompleted => error
    context.fail!(message: "Already completed")
  rescue Domain::Purchase::AlreadyCancelled => error
    context.fail!(message: "Already cancelled")
  end

end
