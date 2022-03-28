class ChangeDatatypePostRecipeIdOfSteps < ActiveRecord::Migration[5.2]
  def change
    change_column :steps, :post_recipe_id, :integer if table_exists? :steps
  end
end
