class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.string :post_id
      t.string :user_id

      t.timestamps
    end
  end
end
