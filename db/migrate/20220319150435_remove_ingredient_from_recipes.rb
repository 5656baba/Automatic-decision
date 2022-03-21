class RemoveIngredientFromRecipes < ActiveRecord::Migration[5.2]
  def change
    remove_column :recipes, :ingredient, :string
  end
end
