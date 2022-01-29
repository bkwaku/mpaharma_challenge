# frozen_string_literal: true

require 'grape-swagger'

class ApplicationApi < Grape::API
  include ApiBaseSetup

  mount Api::V10

  add_swagger_documentation \
    add_version: true,
    hide_documentation_path: true,
    doc_version: configatron.api.latest_version.call,
    info: {
      title: 'Mpharma API Service',
      description: 'Mpharma backend api spec',
      x: {
        logo: {
          url: ''
        }
      }
    }

  desc 'Versions of Mpharma api'
  get :version do
    {
      api_version: configatron.api.latest_version.call
    }
  end

  # Return 404 for all non-matched routes
  route :any, '*path' do
    error! :not_found, 404
  end
end