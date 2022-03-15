class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.text :description, null: false
      t.string :image_id
      t.string :post_recipe_id

      t.timestamps
    end
  end
end
