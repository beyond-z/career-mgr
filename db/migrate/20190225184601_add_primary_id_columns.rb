class AddPrimaryIdColumns < ActiveRecord::Migration[5.2]
  def change
    tables_to_modify = %i(
      coaches_cohorts
      coaches_employers
      employers_industries
      fellows_industries
      fellows_interests
      fellows_majors
      fellows_metros
      fellows_opportunity_types
      industries_opportunities
      interests_opportunities
      locations_opportunities
      majors_opportunities
      metro_relationships
      metros_opportunities
    )

    tables_to_modify.each { |t| add_column t, :id, :primary_key }
  end
end
