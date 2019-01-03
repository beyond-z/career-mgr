class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  def welcome
  end

  def stats
    # see: https://app.asana.com/0/11511088400507/937962981590809
    @res = ActiveRecord::Base.connection.execute("
      SELECT
        opportunity_stages.id, opportunity_stages.name, COUNT(*) 
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
  end
  
  def new_opportunity
    @employers = Employer.all
  end
end
