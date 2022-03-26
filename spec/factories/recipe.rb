FactoryBot.define do
  factory :recipe do
    title { Faker::Lorem.characters(number: 10) }
    image_id { File.open("#{Rails.root}/assets/images/no_image.jpg") }
    url  { "https://example.com/" }
    recipe_ingredient
  end
end
