class AddColumnPostRecipes < ActiveRecord::Migration[5.2]
  def change
    if table_exists? :post_recipes
      add_column :post_recipes, :image_id, :string
      remove_column :post_recipes, :"image", :string
    end
  end
end
