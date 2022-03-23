class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :likes, dependent: :destroy
  validates :comment, presence: true

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
