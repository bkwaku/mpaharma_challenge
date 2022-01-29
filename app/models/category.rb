class Category < ApplicationRecord
  has_many :dignoses, class_name: 'Diagnosis'
  validates_length_of :code, maximum: 6, allow_blank: true
end
