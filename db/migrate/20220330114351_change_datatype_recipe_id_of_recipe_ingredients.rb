class ChangeDatatypeRecipeIdOfRecipeIngredients < ActiveRecord::Migration[5.2]
  def change
    change_column :recipe_ingredients, :recipe_id, :integer
  end
end
