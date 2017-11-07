# frozen_string_literal: true

module EventStore
  class << self
    def client
      Rails.application.config.event_store
    end
  end
end

Rails.application.config.event_store.tap do |event_store|
  event_store.subscribe(Listeners::Members::Purchase, [Events::Member::Purchase])
  event_store.subscribe(Listeners::Members::Withdrawl, [Events::Member::Withdrawl])
end
