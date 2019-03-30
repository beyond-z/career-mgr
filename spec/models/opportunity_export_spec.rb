require 'rails_helper'

RSpec.describe OpportunityExport, type: :model do
  it { should belong_to :user }
  it { should belong_to :opportunity }
end
