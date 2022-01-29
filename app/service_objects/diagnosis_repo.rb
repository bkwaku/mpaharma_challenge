class DiagnosisRepo
  def get_all_diagnosis
    Diagnosis.all
  end

  def create(attributes)
    category = CategoryRepo.new.find_by_id(attributes[:category_id])
    if category.nil?
      raise Errors::RecordNotFoundError, 'Category Does Not Exist'
    else
      Diagnosis.create!(attributes)
    end
  end

  def find_by_id(id)
    Diagnosis.find(id)
  end

  def find_by_code(code)
    Diagnosis.find_by!(code: code)
  end

  def update_diagnosis(params)
    diagnosis = find_by_id(params[:id])
    diagnosis.update!(params.except(:id))
    diagnosis
  end
end