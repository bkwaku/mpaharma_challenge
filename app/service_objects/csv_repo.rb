# frozen_string_literal: true

class CsvRepo
  def upload(file)
    file_content = CSV.read(File.path(file))
    @categories  = []
    @diagnoses  = []

    ActiveRecord::Base.transaction do
      file_content.each do |row|
        @categories << instantiate_category(row)
      end
      Category.import! @categories, on_duplicate_key_ignore: true

      file_content.each do |row|
        @diagnoses << instantiate_diagnosis(row)
      end
      Diagnosis.import! @diagnoses, on_duplicate_key_ignore: true
    end
  end

  private

  def instantiate_category(row)
    Category.new(title: row.last, code: row.first)
  end

  def instantiate_diagnosis(row)
    Diagnosis.new(code: row[1], full_code: row[2], description: row[4], category_id: Category.find_by(code: row.first).id)
  end
end