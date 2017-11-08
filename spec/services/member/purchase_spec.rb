# frozen_string_literal: true

require 'rails_helper'

describe Command::Member::Purchase, type: :service do
  let(:member) { create :member }


  describe "#handler_class" do
    let(:service) { Command::Member::Purchase.new({}) }

    it "returns the handler class" do
      expect(service.handler_class).to eq Handlers::Member::Purchase
    end
  end

  describe "validations" do
    context "with valid purchase criteria" do
      include_examples "central reserve"

      let(:purchase_params) do
        {
          source_coin_id: neo.id,
          source_rate: '0.00370875',
          source_quantity: 26963262554.76916.to_d,
          destination_coin_id: bitcoin.id,
          destination_rate: '1.0',
          destination_quantity: 100000000,
          member_id: member.id
        }
      end

      let(:service) { Command::Member::Purchase.new(purchase_params) }

      it "is valid"do
        expect(service).to be_valid
      end
    end
  end
end
