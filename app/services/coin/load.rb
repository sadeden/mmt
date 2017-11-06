# frozen_string_literal: true

module Services
  module Coin
    class Load < Services::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :rate

      validates :coin_id, :member_id, :quantity, presence: true

      validates :quantity, numericality: { greater_than: 0 }

      alias :aggregate_id :coin_id

      def handler_class
        Handlers::Coin::Load
      end
    end
  end
end
