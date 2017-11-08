class PurchaseOrder < ApplicationRecord
  belongs_to :member
  belongs_to :source_coin, class_name: 'Coin', foreign_key: :source_coin_id
  belongs_to :destination_coin, class_name: 'Coin', foreign_key: :destination_coin_id

  alias :aggregate_id :id

  def handler_class
    Handlers::Purchase::Create
  end

  def stream
    "Domain::Purchase$#{id}"
  end

  def history
    Rails.application.config.event_store.read_stream_events_backward(stream)
  end

  def state
    history.any? ? history.first.data[:state] : nil
  end
end
