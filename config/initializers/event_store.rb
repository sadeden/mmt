# frozen_string_literal: true

Rails.application.config.event_store.tap do |event_store|
  event_store.subscribe(Subscribers::Members::Purchase, [Events::Member::Purchase])
  event_store.subscribe(Subscribers::Members::Withdrawl, [Events::Member::Withdrawl])
end
