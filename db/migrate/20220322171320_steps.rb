class Steps < ActiveRecord::Migration[5.2]
  def change
    drop_table :steps if table_exists? :steps
  end
end
