module Command
  module Purchase
    class Cancel < Command::Base

      attr_accessor :purchase_order_id,
                    :state
 
      validates :purchase_order_id,
                :state,
                presence: true

      alias aggregate_id :purchase_order_id

    end
  end
end
