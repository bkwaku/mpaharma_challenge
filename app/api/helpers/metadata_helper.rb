# frozen_string_literal: true

module Helpers
  module MetadataHelper
    def generate_metadata(resources)
      {
        count: resources.count,
        total_count: resources.total_count,
        total_pages: resources.total_pages,
        prev_page: resources.prev_page,
        next_page: resources.next_page
      }
    end
  end
end
