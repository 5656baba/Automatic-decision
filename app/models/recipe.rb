class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  def self.search(search)
    if search
      Item.where(['ingredient LIKE ?', "%#{search}%"])
    else
      Item.all
    end
  end
end
