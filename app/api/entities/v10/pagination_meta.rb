# frozen_string_literal: true

module Entities
  module V10
    class PaginationMeta < Grape::Entity
      expose :count, documentation: { type: 'Integer' }
      expose :total_pages, documentation: { type: 'Integer' }
      expose :total_count, documentation: { type: 'Integer' }
      expose :prev_page, documentation: { type: 'Integer' }
      expose :next_page, documentation: { type: 'Integer' }
    end
  end
end
