# frozen_string_literal: true

module Entities
  module V10
    class Diagnosis < Grape::Entity
      expose :id, documentation: { type: 'integer' }
      expose :type, documentation: { type: 'string' } do |_comment|
        'diagnosis'
      end
      expose :attributes do
        expose :code, documentation: { type: 'string' }
        expose :description, documentation: { type: 'string' }
        expose :icd_type, documentation: { type: 'string' }
        expose :full_code, documentation: { type: 'string' }
        expose :category_id, documentation: { type: 'string' }
        expose :created_at, documentation: { type: 'string', format: 'date-time' }
        expose :updated_at, documentation: { type: 'string', format: 'date-time' }
      end
    end
  end
end
