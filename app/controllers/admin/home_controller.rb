class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  def welcome
  end

  def stats
    # see: https://app.asana.com/0/11511088400507/937962981590809
    @res = ActiveRecord::Base.connection.execute("
      SELECT
        opportunity_stages.id, opportunity_stages.name AS name, COUNT(*) AS user_count
      FROM
        fellow_opportunities
      INNER JOIN
        fellows on fellow_id = fellows.id
      INNER JOIN
        opportunity_stages on opportunity_stages.id = opportunity_stage_id
      WHERE
        last_name NOT LIKE 'xTest%'
      GROUP BY
        opportunity_stages.name, opportunity_stages.id
      ORDER BY
        opportunity_stages.id
    ")

    @res_details = ActiveRecord::Base.connection.execute("
      SELECT
        opportunity_stages.name AS name, fellows.first_name AS fellow_first_name, fellows.last_name AS fellow_last_name, opportunities.name AS opp_name, employers.name AS emp_name
      FROM
        fellow_opportunities
      INNER JOIN
        fellows on fellow_id = fellows.id
      INNER JOIN
        opportunity_stages on opportunity_stages.id = opportunity_stage_id
      INNER JOIN
        opportunities ON opportunities.id = fellow_opportunities.opportunity_id
      INNER JOIN
        employers ON opportunities.employer_id = employers.id
      WHERE
        last_name NOT LIKE 'xTest%'
      ORDER BY
        opportunity_stages.id, fellows.last_name
    ")

  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
