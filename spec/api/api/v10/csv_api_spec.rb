# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V10::CsvApi, type: :request do
  # Request settings
  let(:params) { { file: Rack::Test::UploadedFile.new('spec/fixtures/small_code.csv', 'text/csv') } }
  let(:base_api_url) { '/api/v1.0/csv/' }

  def send_request(http_method, url, params)
    byebug
    send http_method, url, params: params.to_json, headers: {
      'CONTENT_TYPE' => 'application/json'
    }
  end

  def decoded_json_response(text = response.body)
    ActiveSupport::JSON.decode text
  end

  def dispatch(http_method = :post)
    send_request http_method, request_url, params
  end

  describe 'POST api/v1.0/csv' do
    subject(:dispatch_request) do
      dispatch
      response
    end

    let(:request_url) { base_api_url.to_s }

    context 'without valid params' do
      let!(:params) { nil }

      it 'returns unsupported_media_type' do
        expect(dispatch_request).to have_http_status :unsupported_media_type
      end
    end
  end
end