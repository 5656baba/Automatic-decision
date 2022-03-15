class CreatePostRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :post_recipes do |t|
      t.string :title, null: false
      t.string :image
      t.text :description, null: false
      t.integer :user_id

      t.timestamps
    end
  end
end
