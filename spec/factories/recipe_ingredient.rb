FactoryBot.define do
  factory :recipe_ingredient do
    ingredient { 'java' }
    recipe
  end
end
