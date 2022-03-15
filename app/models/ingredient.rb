class Ingredient < ApplicationRecord
  belongs_to :post_recipe

  validates :name, presence: true
  validates :quantity, presence: true
end
