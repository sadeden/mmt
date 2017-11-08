# frozen_string_literal: true

class CreatePurchase
  include Command::Execute
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      execute Command::Member::Purchase.new(purchase_params.merge(member_id: member_id))
    end
    context.message = "Purchase order created"
  rescue Command::ValidationError => error
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end

  private

  def member_id
    context.member_id
  end

  def destination_coin_id
    context.coin_id
  end

  def purchase_params
    context.purchase_params
  end
end
