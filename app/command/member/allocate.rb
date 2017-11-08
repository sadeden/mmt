# frozen_string_literal: true

module Command
  module Member
    class Allocate < Command::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :rate

      validates :member_id, :coin_id, :quantity, :rate, presence: true

      validates :rate, :quantity, numericality: { greater_than: 0 }

      alias :aggregate_id :member_id

      def handler_class
        Handlers::Member::Allocate
      end
    end
  end
end
