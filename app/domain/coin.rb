# frozen_string_literal: true

module Domain
  class Coin
    include AggregateRoot

    attr_reader :id, :member_id, :quantity, :rate

    def initialize(id:, member_id:, quantity:, rate:)
      @id = id
      @member_id = member_id
      @quantity = quantity
      @rate = rate
    end

    def allocate!
      apply Events::Coin::Allocation.new(data: {
        member_id: member_id,
        quantity: quantity_as_integer,
        rate: rate,
      })
    end

    def deallocate!
      apply Events::Coin::Deallocation.new(data: {
        member_id: member_id,
        quantity: quantity_as_integer,
        rate: rate,
      })
    end

    private

    def apply_allocation(event)
    end

    def apply_deallocation(event)
    end

    def quantity_as_integer
      (quantity.to_d * (10**coin.subdivision)).to_i
    end

    def coin
      @coin ||= ::Coin.find coin_id
    end
  end
end
