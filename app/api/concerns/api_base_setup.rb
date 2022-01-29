# frozen_string_literal: true

require 'grape_logging'

module ApiBaseSetup
  extend ActiveSupport::Concern

  included do

    insert_before Grape::Middleware::Error,
                  GrapeLogging::Middleware::RequestLogger,
                  logger: Rails.configuration.lograge.logger

    # Error Handling
    include ErrorsHandling

    prefix :api
    cascade true
    default_format :json # Default value when content-type is missing.
    format :json # Only respond to requests for json objects. Only respond to JSON content-type.

    # Include helpers
    helpers ::Helpers::MetadataHelper
  end
end
