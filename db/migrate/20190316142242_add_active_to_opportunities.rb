class AddActiveToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :active, :boolean, default: true
    add_index  :opportunities, :active
  end
end
