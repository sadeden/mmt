# frozen_string_literal: true

module Command
  module Coin
    class Load < Command::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :rate

      validates :coin_id,
                :member_id,
                :quantity,
                :rate,
                presence: true

      validates :rate,
                :quantity,
                numericality: { greater_than: 0 }

      validates :coin_id,
                :member_id,
                format: { with: /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\Z/i }

      alias :aggregate_id :coin_id
    end
  end
end
