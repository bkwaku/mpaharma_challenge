# frozen_string_literal: true

module ErrorsHandling
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do
      error!({ error: 'Not found.' }, 404, 'Content-Type' => 'application/json')
    end

    rescue_from Errors::ValidationError, Errors::BadRequest do |exception|
      error!({ error: exception.message }, 400, 'Content-Type' => 'application/json')
    end

    rescue_from Errors::ApiValidationError do |exception|
      Rails.logger.error { exception.message }
      error!(
        {
          error: "Unprocessable entity. #{exception.message}"
        },
        422,
        'Content-Type' => 'application/json'
      )
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      Rails.logger.error { exception.message }
      error!({ error: "Unprocessable entity. #{exception.message}" },
             422, 'Content-Type' => 'application/json')
    end

    rescue_from ActiveRecord::ActiveRecordError do |exception|
      Rails.logger.error { exception.message }
      error!({ error: 'Unprocessable entity.' }, 422, 'Content-Type' => 'application/json')
    end

    rescue_from Errors::UnprocessableEntity do |exception|
      Rails.logger.error { exception.message }
      error!(
        {
          errors: [
            {
              title: 'Unprocessable Entity', detail: exception.message, status: 422,
              meta: exception.metadata
            }
          ]
        }, 422, 'Content-Type' => 'application/json'
      )
    end

    rescue_from :all do |exception|
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
      error!({ error: 'Server error.' }, 500, 'Content-Type' => 'application/json')
    end
  end
end
