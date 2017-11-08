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

    # %%TODO%% Events::Member::Purchase's aggregate is no longer Coin. Perhapse its a PurchaseOrder model?
    # def purchase!
    #   source_coin = ::Coin.find source_coin_id
    #   destination_coin = ::Coin.find destination_coin_id

    #   apply Events::Member::Purchase.new(data: {
    #     source_coin_id: source_coin_id,
    #     source_rate: source_rate,
    #     source_quantity: source_coin.store_as_integer(source_quantity),
    #     source_subdivision: source_coin.subdivision,
    #     destination_coin_id: destination_coin_id,
    #     destination_rate: destination_rate,
    #     destination_quantity: destination_coin.store_as_integer(destination_quantity),
    #     destination_subdivision: destination_coin.subdivision,
    #     member_id: member_id
    #   })
    # end

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

    # def apply_purchase(event)
    # end

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
