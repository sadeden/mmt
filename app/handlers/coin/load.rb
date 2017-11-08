# frozen_string_literal: true

class Handlers::Coin::Load
  include Command::Handler

  def call(command)
    with_aggregate(Domain::Coin, command.aggregate_id, attributes(command)) do |coin|
      coin.load!
    end
  end

  private

  def attributes(command)
    {
      member_id: command.member_id,
      quantity: command.quantity,
      rate: command.rate,
    }
  end
end
