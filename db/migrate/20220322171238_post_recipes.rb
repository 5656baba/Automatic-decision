class PostRecipes < ActiveRecord::Migration[5.2]
  def change
    drop_table :post_recipes if table_exists? :post_recipes
  end
end
