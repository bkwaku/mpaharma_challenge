class Category < ApplicationRecord
  validates_length_of :code, maximum: 6, allow_blank: true
end
