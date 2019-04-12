class AddExportBooleanToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :export, :boolean, default: false
    add_index :opportunities, :export
  end
end
