# frozen_string_literal: true

module Services
  class ValidationError < StandardError
    attr_reader :messages

    def initialize(messages)
      @messages = messages
      super
    end
  end
end
