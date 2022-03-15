class ChangeDatatypePostRecipeIdOfIngredients < ActiveRecord::Migration[5.2]
  def change
    change_column :ingredients, :post_recipe_id, :integer
  end
end
