module Domain
  class Member < OpenStruct
    include AggregateRoot

    def purchase!
      source_coin = ::Coin.find source_coin_id
      destination_coin = ::Coin.find destination_coin_id

      apply Events::Member::Purchase.new(data: {
        source_coin_id: source_coin_id,
        source_rate: source_rate,
        source_quantity: source_coin.store_as_integer(source_quantity),
        source_subdivision: coin.subdivision,
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_coin.store_as_integer(destination_quantity),
        destination_subdivision: coin.subdivision,
        member_id: member_id
      })
    end

    def allocate!
      coin = ::Coin.find coin_id
      apply Events::Member::Allocation.new(data: {
        coin_id: coin_id,
        quantity: coin.store_as_integer(quantity),
        subdivision: coin.subdivision,
        rate: rate,
      })
    end

    def deallocate!
      coin = ::Coin.find coin_id
      apply Events::Member::Deallocation.new(data: {
        coin_id: coin_id,
        quantity: coin.store_as_integer(quantity),
        subdivision: coin.subdivision,
        rate: rate,
      })
    end

    def withdraw!
      coin = ::Coin.find coin_id
      apply Events::Member::Withdrawl.new(data: {
        coin_id: coin_id,
        quantity: coin.store_as_integer(quantity),
        rate: rate
      })
    end

    private

    def apply_purchase(event)
    end

    def apply_allocation(event)
    end

    def apply_deallocation(event)
    end

    def apply_withdrawl(event)
    end
  end
end
