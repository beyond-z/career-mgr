require 'rails_helper'

RSpec.describe Metro, type: :model do
  ##############
  # Associations
  ##############

  it { should have_and_belong_to_many :opportunities }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :code }
  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    before { create :metro }
    
    it { should validate_uniqueness_of(:code).case_insensitive }
    it { should validate_uniqueness_of(:name) }
  end
  
  ###############
  # Class methods
  ###############
  
  describe '::load_txt' do
    it "loads the contents of the TXT file into the db" do
      Metro.load_txt("#{Rails.root}/spec/fixtures/msa-sample.txt")
      expect(Metro.count).to eq(5)

      metro = Metro.find_by code: '0040'
      expect(metro.name).to eq("Abilene, TX")
    end
    
    it "clears table first" do
      create :metro
      Metro.load_txt("#{Rails.root}/spec/fixtures/msa-sample.txt")

      expect(Metro.count).to eq(5)
    end
  end
end