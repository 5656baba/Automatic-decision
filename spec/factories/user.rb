FactoryBot.define do
  factory :user do
    last_name { Faker::Lorem.characters(number: 10) }
    first_name{ Faker::Lorem.characters(number: 10) }
    last_name_kana{ Faker::Lorem.characters(number: 10) }
    first_name_kana{ Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app/assets/images/no_image.jpg')) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
