# frozen_string_literal: true

module Domain
  class Coin < OpenStruct
    include AggregateRoot

    def load!
      coin = ::Coin.find coin_id
      binding.pry
      apply Events::Coin::Loaded.new(data: {
        member_id: member_id,
        quantity: coin.store_as_integer(quantity),
        subdivision: coin.subdivision,
        rate: rate,
        by: member.email
      })
    end

    def allocate!
      coin = ::Coin.find coin_id
      apply Events::Coin::Allocation.new(data: {
        coin_id: coin_id,
        quantity: coin.store_as_integer(quantity),
        subdivision: coin.subdivision,
        rate: rate,
      })
    end

    def deallocate!
      coin = ::Coin.find coin_id
      apply Events::Coin::Deallocation.new(data: {
        coin_id: coin_id,
        quantity: coin.store_as_integer(quantity),
        subdivision: coin.subdivision,
        rate: rate,
      })
    end

    def member
      Member.find_by!(id: member_id)
    end

    private

    def apply_loaded(event)
    end

    def apply_allocation(event)
    end

    def apply_deallocation(event)
    end

  end
end
