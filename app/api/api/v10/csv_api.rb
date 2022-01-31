# frozen_string_literal: true

module Api
  class V10
    class CsvApi < Grape::API

      namespace :csv do
        helpers do
          def declared_params
            @declared_params ||= declared(params, include_missing: false)
          end

          def csv_repo
            @csv ||= CSVRepo.new
          end
        end

        desc 'Create diagnosis upload'
        params do
          requires :file, type: File, desc: 'CSV FILE'
        end

        post do

          csv_repo.create(declared_params)

          status 204
        end
      end
    end
  end
end
