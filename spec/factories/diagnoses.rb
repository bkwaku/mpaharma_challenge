FactoryBot.define do
  factory :diagnosis do
    description { Faker::Name.unique.name }
  end
end
