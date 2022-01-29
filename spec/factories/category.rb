
FactoryBot.define do
  factory :category do
    code { Faker::Name.unique.name }
    title { Faker::Name.unique.name }
  end
end