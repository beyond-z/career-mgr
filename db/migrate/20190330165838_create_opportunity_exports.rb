class CreateOpportunityExports < ActiveRecord::Migration[5.2]
  def change
    create_table :opportunity_exports do |t|
      t.integer :user_id
      t.integer :opportunity_id

      t.timestamps
    end
    add_index :opportunity_exports, :user_id
    add_index :opportunity_exports, :opportunity_id
  end
end
