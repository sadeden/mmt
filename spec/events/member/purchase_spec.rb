# frozen_string_literal: true

require 'rails_helper'

describe Events::Member::Purchase, type: :event do
  let(:member) { create :member }

  let(:event) do
    Events::Member::Purchase.new(data: {
      source_coin_id: source_coin_id,
      source_rate: source_rate,
      source_quantity: source_quantity,
      destination_coin_id: destination_coin_id,
      destination_rate: destination_rate,
      destination_quantity: destination_quantity,
      member_id: member.id
    })
  end


end
