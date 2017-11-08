# frozen_string_literal: true

module Command
  module Coin
    class Allocate < Command::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :rate

      validates :member_id, :coin_id, :quantity, :rate, presence: true

      validates :rate, :quantity, numericality: { greater_than: 0 }

      alias :aggregate_id :coin_id

      def handler_class
        Handlers::Coin::Allocate
      end
    end
  end
end
