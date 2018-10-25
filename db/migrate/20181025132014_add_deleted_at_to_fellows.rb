class AddDeletedAtToFellows < ActiveRecord::Migration[5.2]
  def change
    add_column :fellows, :deleted_at, :datetime
    add_index  :fellows, :deleted_at
  end
end
