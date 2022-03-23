class PostRecipes < ActiveRecord::Migration[5.2]
  def change
    drop_table :post_recipes
  end
end
