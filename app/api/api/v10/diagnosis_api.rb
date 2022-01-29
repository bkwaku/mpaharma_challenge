# frozen_string_literal: true

module Api
  class V10
    class DiagnosisApi < Grape::API

      namespace :diagnosis do
        helpers do
          def declared_params
            @declared_params ||= declared(params, include_missing: false)
          end

          def diagnosis_repo
            @diagnosis_repo ||= DiagnosisRepo.new
          end

          def diagnosis
            @diagnosis ||= DiagnosisRepo.new.get_all_diagnosis
          end
        end

        desc 'Return list of diagnosis',
             success: Entities::V10::Diagnosis
        paginate
        get do
          resources = paginate diagnosis
          metadata = generate_metadata resources

          present :data, resources, with: Entities::V10::Diagnosis
          present :meta, metadata, with: Entities::V10::PaginationMeta
        end

        desc 'Create diagnosis',
             success: Entities::V10::Diagnosis
        params do
          optional :code, type: String, desc: 'Diagnosis code'
          optional :description, type: String, desc: 'Diagnosis title'
          optional :icd_type, type: String, desc: 'Diagnosis icd_type'
          optional :full_code, type: String, desc: 'Diagnosis full_code'
          requires :category_id, type: String, desc: 'Diagnosis Category ID'
        end

        post do

          diagnosis = diagnosis_repo.create(declared_params)

          present :data, diagnosis, with: Entities::V10::Diagnosis
        end

        route_param :id do
          helpers do
            def diagnosis
              @diagnosis ||= diagnosis_repo.find_by_id(params[:id])
            end
          end

          params do
            requires :id, type: String, desc: 'Diagnosis id'
          end

          desc 'Show Diagnosis by id',
               success: Entities::V10::Diagnosis
          get do
            present :data, diagnosis, with: Entities::V10::Diagnosis
          end

          desc 'Patch Diagnosis by id',
               success: Entities::V10::Diagnosis
          params do
            optional :code, type: String, desc: 'Diagnosis code'
            optional :description, type: String, desc: 'Diagnosis title'
            optional :icd_type, type: String, desc: 'Diagnosis icd_type'
            optional :full_code, type: String, desc: 'Diagnosis full_code'
            optional :category_id, type: String, desc: 'Diagnosis Category ID'
          end
          patch do
            updated_diagnosis = diagnosis_repo.update_diagnosis(params)

            present :data, updated_diagnosis, with: Entities::V10::Diagnosis
          end

          desc 'Destroy Diagnosis by id'
          delete do
            diagnosis.destroy!
            status 204
          end
        end
      end
    end
  end
end
