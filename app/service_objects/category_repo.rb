class CategoryRepo
  def get_all_categories
    Category.all
  end

  def create(attributes)
    Category.create!(attributes)
  end

  def find_by_id(id)
    Category.find(id)
  end

  def update_category(params)
    category = find_by_id(params[:id])
    category.update!(params.except(:id))
    category
  end
end