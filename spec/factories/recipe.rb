FactoryBot.define do
  factory :recipe do
    title { 'ruby' }
    image_id { 'https://www.google.co.jp/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png' }
    url { "https://example.com/" }
  end
end
