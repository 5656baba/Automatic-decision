FactoryBot.define do
  factory :recipe_ingredient do
    ingredient { Faker::Lorem.characters(number: 10) }
    recipe
  end
end