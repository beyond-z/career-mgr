class AddRegionIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :region_id, :integer
    add_index :users, :region_id
  end
end
