class UpdateOpportunityPriorities < ActiveRecord::Migration[5.2]
  def change
    # Re-save all opportunities, triggering the set_priority callback.
    # This is necessary because we weren't properly re-setting priority
    # when opps were being published via CSV export.
    Opportunity.all.each(&:save)
  end
end
