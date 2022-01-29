# frozen_string_literal: true

module Entities
  module V10
    class Category < Grape::Entity
      expose :id, documentation: { type: 'integer' }
      expose :type, documentation: { type: 'string' } do |_comment|
        'category'
      end
      expose :attributes do
        expose :code, documentation: { type: 'string' }
        expose :title, documentation: { type: 'string' }
        expose :created_at, documentation: { type: 'string', format: 'date-time' }
        expose :updated_at, documentation: { type: 'string', format: 'date-time' }
      end
    end
  end
end
