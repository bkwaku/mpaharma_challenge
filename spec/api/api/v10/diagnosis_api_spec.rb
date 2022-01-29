# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V10::DiagnosisApi, type: :request do

  let!(:category) { create :category, code: '12345' }

  let!(:diagnosis_1) { create :diagnosis, category: category }
  let!(:diagnosis_2) { create :diagnosis, code: '1234', category: category }
  let!(:diagnosis_3) { create :diagnosis, code: '5656', category: category }

  # Request settings
  let(:params) { nil }
  let(:base_api_url) { '/api/v1.0/diagnosis' }
  let(:data) { decoded_json_response['data'] }
  let(:meta) { decoded_json_response['meta'] }

  def send_request(http_method, url, params)
    if %i[get delete].include?(http_method)
      send http_method, url, params: params
    else
      send http_method, url, params: params.to_json, headers: {
        'CONTENT_TYPE' => 'application/json'
      }
    end
  end

  def decoded_json_response(text = response.body)
    ActiveSupport::JSON.decode text
  end

  def dispatch(http_method = :get)
    send_request http_method, request_url, params
  end

  describe 'GET api/v1.0/diagnosis' do
    subject(:dispatch_request) do
      dispatch
      response
    end

    let(:request_url) { base_api_url.to_s }

    it 'returns http status 200 with appropriate response format' do
      expect(dispatch_request).to have_http_status :ok
      expect(meta['total_count']).to eq(Diagnosis.all.size)
    end
  end

  describe 'POST api/v1.0/diagnosis' do
    subject(:dispatch_request) do
      dispatch :post
      response
    end

    let(:request_url) { base_api_url.to_s }

    context 'without valid params' do
      let(:params) { nil }

      it 'returns unprocessable_entity' do
        expect(dispatch_request).to have_http_status :internal_server_error
      end
    end

    context 'with valid params' do
      let(:params) { { code: '34dre', description: 'Something', icd_type: 30, full_code: 'jdnd87', category_id: category.id} }
      it 'returns created' do
        expect(dispatch_request).to have_http_status :created
        expect(decoded_json_response['data']['type']).to eq 'diagnosis'
        expect(decoded_json_response['data']['attributes']['code']).to eq '34dre'
        expect(decoded_json_response['data']['attributes']['description']).to eq 'Something'
        expect(decoded_json_response['data']['attributes']['icd_type']).to eq 30
        expect(decoded_json_response['data']['attributes']['full_code']).to eq 'jdnd87'
        expect(decoded_json_response['data']['attributes']['category_id']).to eq category.id
      end
    end

    context 'with category does not exist' do
      let(:params) { { code: '34dre', description: 'Something', icd_type: 30, full_code: 'jdnd87', category_id: '45'} }
      it 'returns created' do
        expect(dispatch_request).to have_http_status :not_found
      end
    end
  end

  describe 'GET api/v1.0/diagnosis/:id' do
    subject(:dispatch_request) do
      dispatch
      response
    end

    let(:request_url) { "#{base_api_url}/#{diagnosis_1.id}" }

    it 'returns http status 200 with appropriate response format' do
      expect(dispatch_request).to have_http_status :ok
      expect(data).to eq(
                        'id' => diagnosis_1.id,
                        'type' => 'diagnosis',
                        'attributes' => {
                          'created_at' => diagnosis_1.created_at.utc.as_json,
                          'updated_at' => diagnosis_1.updated_at.utc.as_json,
                          'description' => diagnosis_1.description,
                          'code' => diagnosis_1.code,
                          'icd_type' => diagnosis_1.icd_type,
                          'full_code' => diagnosis_1.full_code,
                          'category_id' => diagnosis_1.category.id,
                        }.deep_stringify_keys
                      )
    end
  end

  describe 'PATCH api/v1.0/diagnosis/:id' do
    subject(:dispatch_request) do
      dispatch :patch
      response
    end

    let(:request_url) { "/api/v1.0/diagnosis/#{diagnosis_1.id}" }


    context 'when valid params are passed' do
      let(:params) { { description: 'new name', code: 'zooo1' } }

      it 'updates the diagnosis' do
        expect(dispatch_request).to have_http_status :ok
        expect(decoded_json_response['data']['type']).to eq 'diagnosis'
        expect(decoded_json_response['data']['attributes']['description']).to eq 'new name'
        expect(decoded_json_response['data']['attributes']['code']).to eq 'zooo1'
      end
    end
  end

  describe 'DELETE api/v1.0/diagnosis/:id' do
    subject(:dispatch_request) do
      dispatch :delete
      response
    end

    let(:request_url) { "/api/v1.0/diagnosis/#{diagnosis_id}" }
    let(:diagnosis_id) { 'fake' }

    it 'when the diagnosis does not exist' do
      expect(dispatch_request).to have_http_status :not_found
    end

    context 'when diagnosis exists' do
      let(:diagnosis_id) { diagnosis_1.id }

      it do
        expect(dispatch_request).to have_http_status :no_content
        expect(Diagnosis.where(id: diagnosis_1.id).length).to eq 0
      end
    end
  end
end