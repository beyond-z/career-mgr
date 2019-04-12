FactoryBot.define do
  factory :opportunity_export do
    association :user
    association :opportunity
  end
end
