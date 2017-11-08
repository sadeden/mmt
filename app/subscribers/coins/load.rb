# frozen_string_literal: true

module Subscribers
  module Coins
    class Load < Subscribers::Base

      def call(event)
        execute Command::Coin::Allocate.new(event.data)
      end

    end
  end
end
