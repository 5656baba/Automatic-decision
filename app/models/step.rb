class Step < ApplicationRecord
  belongs_to :post_recipe
  validates :description, presence: true
  attachment :image
end
