# frozen_string_literal: true

class WithdrawCoin
  include Services::Execute
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      execute Services::Member::Withdraw.new(withdrawl_params)
    end
    context.message = "Withdrawl successful"
  rescue Services::ValidationError => error
    context.fail!(message: error.messages.values.flatten.uniq.join(' | '))
  end

  private

  def member_id
    context.member_id
  end

  def withdrawl_params
    context.withdrawl_params
  end
end
