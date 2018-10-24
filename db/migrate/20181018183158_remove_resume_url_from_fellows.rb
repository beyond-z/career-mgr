class RemoveResumeUrlFromFellows < ActiveRecord::Migration[5.2]
  def change
    remove_column :fellows, :resume_url, :string
  end
end
