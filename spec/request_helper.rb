# frozen_string_literal: true

module RequestHelpers
  def send_request(http_method, url, params)
    if %i[get delete].include?(http_method)
      send http_method, url, params: params
    else
      send http_method, url, params: params.to_json, headers: {
        'CONTENT_TYPE' => 'application/json'
      }
    end
  end
end
