module Services
  module Execute
    def execute(transaction)
      transaction.validate!
      handler_for(transaction).call(transaction)
    end

    private

    def handler_for(transaction)
      transaction.handler_class.new
    end
  end
end
