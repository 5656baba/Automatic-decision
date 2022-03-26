FactoryBot.define do
  factory :like do
    association :comment
    association :post
    user{comment.user}
  end
end