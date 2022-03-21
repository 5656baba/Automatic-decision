class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :image_id
      t.string :title
      t.string :ingredient

      t.timestamps
    end
  end
end
