class Diagnosis < ApplicationRecord
  belongs_to :category

  validates_uniqueness_of :code
end
