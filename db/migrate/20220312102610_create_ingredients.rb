class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.string :quantity, null: false
      t.string :post_recipe_id

      t.timestamps
    end
  end
end
