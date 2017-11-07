class PurchaseOrder < ApplicationRecord
  belongs_to :member
  belongs_to :source_coin, class_name: 'Coin', foreign_key: :source_coin_id
  belongs_to :destination_coin, class_name: 'Coin', foreign_key: :destination_coin_id

  STATES = [:pending, :in_progress, :completed, :cancelled].freeze

  def stream
    "Domain::Purchase$#{id}"
  end

  def history
    Rails.application.config.event_store.read_stream_events_backward(stream)
  end

  def state
    history.any? ? history.first.data[:state] : nil
  end

  def pending!
    return false if [:in_progress, :cancelled, :completed].include? state
    return true if [:pending].include? state
    Rails.application.config.event_store.publish_event(Events::Purchase::Created.new(data: {
      purchase_order_id: id,
      state: :pending
    }), stream_name: stream)
  end

  def in_progress!
    return false if [:completed, :cancelled].include? state
    return true if [:in_progress].include? state
    Rails.application.config.event_store.publish_event(Events::Purchase::InProgress.new(data: {
      purchase_order_id: id,
      state: :in_progress
    }), stream_name: stream)
  end

  def confirm!
    return false if [:cancelled].include? state
    return true if [:completed].include? state
    Rails.application.config.event_store.publish_event(Events::Purchase::Confirmed.new(data: {
      purchase_order_id: id,
      state: :confirm
    }), stream_name: stream)
  end

  def complete!
    return false if [:cancelled].include? state
    return true if [:completed].include? state
    Rails.application.config.event_store.publish_event(Events::Purchase::Completed.new(data: {
      purchase_order_id: id,
      state: :completed
    }), stream_name: stream)
  end

  def cancel!
    return false if [:in_progress, :completed, :cancelled].include? state
    return true if [:cancelled].include? state
    Rails.application.config.event_store.publish_event(Events::Purchase::Cancelled.new(data: {
      purchase_order_id: id,
      state: :cancelled
    }), stream_name: stream)
  end
end
