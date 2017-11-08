module Domain
  class Purchase
    include AggregateRoot

    attr_reader :purchase_order, :id, :state

    def initialize(id:, state:)
      @purchase_order = ::PurchaseOrder.find(id)
      @state = purchase_order.state
    end

    AlreadyPending = Class.new(StandardError)
    AlreadyInProgress = Class.new(StandardError)
    AlreadyConfirmed = Class.new(StandardError)
    AlreadyCancelled = Class.new(StandardError)
    AlreadyCompleted = Class.new(StandardError)

    def pending!
      raise AlreadyPending unless state.nil?

      apply Events::Purchase::Pending.new(data: {
        purchase_order_id: id,
        state: :pending
      })
    end

    def in_progress!
      raise AlreadyCompleted if state == :completed
      raise AlreadyCancelled if state == :cancelled
      raise AlreadyConfirmed if state == :confirmed
      raise AlreadyInProgress if state == :in_progress

      apply Events::Purchase::InProgress.new(data: {
        purchase_order_id: id,
        state: :in_progress
      })
    end

    def confirm!
      raise AlreadyCancelled if state == :cancelled
      raise AlreadyCompleted if state == :completed
      raise AlreadyConfirmed if state == :confirmed

      apply Events::Purchase::Confirmed.new(data: {
        purchase_order_id: id,
        state: :confirm
      })
    end

    def complete!
      raise AlreadyCancelled if state == :cancelled
      raise AlreadyCompleted if state == :completed

      apply Events::Purchase::Completed.new(data: {
        purchase_order_id: id,
        state: :completed
      })
    end

    def cancel!
      raise AlreadyCompleted if state == :completed
      raise AlreadyCancelled if state == :cancelled
      raise AlreadyConfirmed if state == :confirmed
      raise AlreadyInProgress if state == :in_progress

      apply Events::Purchase::Cancelled.new(data: {
        purchase_order_id: id,
        state: :cancelled
      })
    end

    private

    def apply_pending(event)
      @state = event.data[:state]
    end

    def apply_in_progress(event)
      @state = event.data[:state]
    end

    def apply_confirmed(event)
      @state = event.data[:state]
    end

    def apply_completed(event)
      @state = event.data[:state]
    end

    def apply_cancelled(event)
      @state = event.data[:state]
    end
  end
end

