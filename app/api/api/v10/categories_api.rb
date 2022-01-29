# frozen_string_literal: true

module Api
  class V10
    class CategoriesApi < Grape::API

      namespace :categories do
        helpers do
          def declared_params
            @declared_params ||= declared(params, include_missing: false)
          end

          def category_repo
            @category_repo ||= CategoryRepo.new
          end

          def categories
            @categories ||= CategoryRepo.new.get_all_categories
          end
        end

        desc 'Return list of categories',
             success: Entities::V10::Category
        paginate
        get do
          resources = paginate categories
          metadata = generate_metadata resources

          present :data, resources, with: Entities::V10::Category
          present :meta, metadata, with: Entities::V10::PaginationMeta
        end

        desc 'Create Category',
             success: Entities::V10::Category
        params do
          requires :code, type: String, desc: 'Category code'
          requires :title, type: String, desc: 'Category title'
          end

        post do

          category = category_repo.create(declared_params)

          present :data, category, with: Entities::V10::Category
        end

        route_param :id do
          helpers do
            def category
              @category ||= category_repo.find_by_id(params[:id])
            end
          end

          params do
            requires :id, type: String, desc: 'Category id'
          end

          desc 'Show Category by id',
               success: Entities::V10::Category
          get do
            present :data, category, with: Entities::V10::Category
          end

          desc 'Patch Category by id',
               success: Entities::V10::Category
          params do
            optional :code, type: String, desc: 'Category code'
            optional :title, type: String, desc: 'Category title'
          end
          patch do
            updated_category = category_repo.update_category(params)

            present :data, updated_category, with: Entities::V10::Category
          end

          desc 'Destroy Category by id'
          delete do
            category.destroy!
            status 204
          end
        end
      end
    end
  end
end
