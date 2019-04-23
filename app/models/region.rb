class Region < ApplicationRecord
  has_many :opportunities
  has_many :users
  
  validates :name, :position, presence: true, uniqueness: true
  
  class << self
    def types
      return @types if defined?(@types)
      @types = YAML.load(File.read("#{Rails.root}/config/regions.yml"))
    end
  end
end
