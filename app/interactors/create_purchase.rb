# frozen_string_literal: true

class CreatePurchase
  include Services::Execute
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      execute Services::Member::Purchase.new(purchase_params.merge(member_id: member_id))
    end
    context.message = "Purchase order created"
  rescue Services::ValidationError => error
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end

  protected

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
