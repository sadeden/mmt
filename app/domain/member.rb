# frozen_string_literal: true

module Domain
  class Member
    include AggregateRoot

    attr_reader :id, :coin_id, :quantity, :rate

    def initialize(id:, coin_id:, quantity:, rate:)
      @id = id
      @coin_id = coin_id
      @quantity = quantity
      @rate = rate
    end

    def allocate!
      apply Events::Member::Allocation.new(data: {
        coin_id: coin_id,
        quantity: quantity_as_integer,
        rate: rate,
      })
    end

    def deallocate!
      apply Events::Member::Deallocation.new(data: {
        coin_id: coin_id,
        quantity: quantity_as_integer,
        rate: rate,
      })
    end

    def withdraw!
      apply Events::Member::Withdrawl.new(data: {
        coin_id: coin_id,
        quantity: quantity_as_integer,
        rate: rate
      })
    end

    private

    def apply_allocation(event)
    end

    def apply_deallocation(event)
    end

    def apply_withdrawl(event)
    end

    def quantity_as_integer
      (quantity.to_d * (10**coin.subdivision)).to_i
    end

    def coin
      @coin ||= ::Coin.find coin_id
    end
  end
end
