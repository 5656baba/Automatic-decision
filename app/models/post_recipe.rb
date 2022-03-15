class PostRecipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps
  attachment :image
end
