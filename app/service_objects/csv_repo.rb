# frozen_string_literal: true

class CsvRepo
  def upload(file)
    @file_content = CSV.read(File.path(file))

    @file_content.each do |row|
      categories  = []
      category = Category.new(title: row.last, code: row.first)
      categories << category

      diagnoses  = []
      diagnosis = Diagnosis.new(code: row[1], full_code: row[2], description: row[4])
      diagnoses << diagnosis

      ActiveRecord::Base.transaction do
        Category.import! categories, on_duplicate_key_ignore: true
        Diagnosis.import! diagnoses, on_duplicate_key_ignore: true
      end
    end
  end
end