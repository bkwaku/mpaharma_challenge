
FactoryBot.define do
  factory :category do
    code { Faker::Lorem.words(6) }
    title { Faker::Name.unique.name }
  end
end