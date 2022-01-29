# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V10::CategoriesApi, type: :request do

  let!(:category_1) { create :category, code: '123' }
  let!(:category_2) { create :category, code: '456' }
  let!(:category_3) { create :category, code: '890' }

  # Request settings
  let(:params) { nil }
  let(:base_api_url) { '/api/v1.0/categories' }
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

  describe 'GET api/v1.0/categories' do
    subject(:dispatch_request) do
      dispatch
      response
    end

    let(:request_url) { base_api_url.to_s }

    it 'returns http status 200 with appropriate response format' do
      expect(dispatch_request).to have_http_status :ok
      expect(meta['total_count']).to eq(Category.all.size)
    end
  end

  describe 'POST api/v1.0/categories' do
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

    context 'with blank code param ' do
      let(:params) { { code: '', title: 'Something' } }
      it 'returns created' do
        expect(dispatch_request).to have_http_status :created
        expect(decoded_json_response['data']['type']).to eq 'category'
        expect(decoded_json_response['data']['attributes']['code']).to eq ''
        expect(decoded_json_response['data']['attributes']['title']).to eq 'Something'
      end
    end

    context 'with code and title params' do
      let(:params) { { title: 'Some name', code: '98823' } }

      it 'returns created' do
        expect(dispatch_request).to have_http_status :created
        expect(decoded_json_response['data']['type']).to eq 'category'
        expect(decoded_json_response['data']['attributes']['title']).to eq 'Some name'
        expect(decoded_json_response['data']['attributes']['code']).to eq '98823'
      end
    end
  end

  describe 'GET api/v1.0/categories/:id' do
    subject(:dispatch_request) do
      dispatch
      response
    end

    let(:request_url) { "#{base_api_url}/#{category_1.id}" }

    it 'returns http status 200 with appropriate response format' do
      expect(dispatch_request).to have_http_status :ok
      expect(data).to eq(
                        'id' => category_1.id,
                        'type' => 'category',
                        'attributes' => {
                          'created_at' => category_1.created_at.utc.as_json,
                          'updated_at' => category_1.updated_at.utc.as_json,
                          'title' => category_1.title,
                          'code' => category_1.code
                        }.deep_stringify_keys
                      )
    end
  end

  describe 'PATCH api/v1.0/categories/:id' do
    subject(:dispatch_request) do
      dispatch :patch
      response
    end

    let(:request_url) { "/api/v1.0/categories/#{category_1.id}" }


    context 'when valid params are passed' do
      let(:category_id) { category_1.id }
      let(:params) { { title: 'new name', code: 'zooo1' } }

      it 'updates the category' do
        expect(dispatch_request).to have_http_status :ok
        expect(decoded_json_response['data']['type']).to eq 'category'
        expect(decoded_json_response['data']['attributes']['title']).to eq 'new name'
        expect(decoded_json_response['data']['attributes']['code']).to eq 'zooo1'
      end
    end
  end

  describe 'DELETE api/v1.0/segment_folders/:id' do
    subject(:dispatch_request) do
      dispatch :delete
      response
    end

    let(:request_url) { "/api/v1.0/categories/#{category_id}" }
    let(:category_id) { 'fake' }

    it 'when the category does not exist' do
      expect(dispatch_request).to have_http_status :not_found
    end

    context 'when category exists' do
      let(:category_id) { category_1.id }

      it do
        expect(dispatch_request).to have_http_status :no_content
        expect(Category.where(id: category_1.id).length).to eq 0
      end
    end
  end
end