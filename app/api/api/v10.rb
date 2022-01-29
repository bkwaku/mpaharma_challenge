# frozen_string_literal: true

module Api
  class V10 < Grape::API
    version configatron.api.exposed_versions_for.call('v1.0'), using: :path, cascade: true

    content_type :json, 'application/json'

    mount ::Api::V10::CategoriesApi
    mount ::Api::V10::DiagnosisApi

  end
end