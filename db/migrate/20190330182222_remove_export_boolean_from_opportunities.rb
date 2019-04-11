class RemoveExportBooleanFromOpportunities < ActiveRecord::Migration[5.2]
  def up
    remove_index  :opportunities, :export
    remove_column :opportunities, :export
  end
  
  def down
    add_column :opportunities, :export, :boolean
    add_index  :opportunities, :export
  end
end
