class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :user_id, presence: true
  validates :comment_id, uniqueness: { scope: :user_id }, presence: true
  validates :post_id, uniqueness: { scope: :user_id }, presence: true
end
