# frozen_string_literal: true

module Errors
  class ValidationError < StandardError
  end

  class BadRequest < StandardError
  end

  class InvalidConfiguration < StandardError
  end

  class RecordNotFoundError < StandardError
    attr_reader :metadata

    def initialize(message, metadata = nil)
      super(message)
      @metadata = metadata
    end
  end

  class ApiValidationError < StandardError
  end

  class ApiConfigurationError < StandardError
  end

  class UnprocessableEntity < StandardError
    attr_reader :metadata

    def initialize(message, metadata)
      super(message)
      @metadata = metadata
    end
  end
end
