module Command
  class Base
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Conversion

    def initialize(attributes = {})
      super
    end

    def validate!
      raise Command::ValidationError.new(errors.messages) unless valid?
    end

    def persisted?
      false
    end
  end
end
