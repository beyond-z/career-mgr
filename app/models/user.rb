require 'fellow_user_matcher'

class User < ApplicationRecord
  ADMIN_DOMAIN_WHITELIST = ['bebraven.org']
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_one :fellow
  
  has_many :opportunity_exports
  
  before_create :attempt_admin_set, unless: :is_admin?
  after_save :attempt_fellow_match, if: :missing_fellow?
  
  scope :admin, -> { where(is_admin: true) }
  
  def role
    if is_admin?
      :admin
    elsif is_fellow?
      :fellow
    else
      nil
    end
  end
  
  def export_ids
    opportunity_exports.pluck(:opportunity_id)
  end
  
  def add_export_ids opportunity_ids
    Rails.logger.info("ids: opportunity_ids#{opportunity_ids.inspect} - export_ids#{export_ids.inspect}: #{(opportunity_ids - export_ids).inspect}")
    (opportunity_ids.map(&:to_i) - export_ids).each do |opportunity_id|
      opportunity_exports.create opportunity_id: opportunity_id
    end
  end
  
  def remove_export_ids opportunity_ids
    opportunity_exports.where(opportunity_id: (opportunity_ids.map(&:to_i) & export_ids)).destroy_all
  end
  
  def remove_all_exports
    opportunity_exports.destroy_all
  end
  
  def ready_for_export
    opportunity_exports.map(&:opportunity)
  end
  
  private

  def attempt_admin_set
    return if email.nil?
    return if FellowUserMatcher.match?(email)
    
    domain = email.split('@').last
    self.is_admin = ADMIN_DOMAIN_WHITELIST.include?(domain)
  end
  
  def attempt_fellow_match
    FellowUserMatcher.match(email)
  end

  def missing_fellow?
    fellow.nil?
  end
  
  def password_required?
    false
  end
end
