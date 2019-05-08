class Admin::OpportunitiesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:mark_for_export, :queued]
  
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_employer
  before_action :set_opportunity, only: [:show, :edit, :update, :unpublish, :destroy]

  # GET /opportunities
  # GET /opportunities.json
  def index
  end
  
  def export
    respond_to do |format|
      format.csv do
        @opportunities = exportable_opportunities
        @opportunities.each(&:publish!)
        
        current_user.remove_all_exports
    
        headers['Content-Disposition'] = "attachment; filename=\"opportunities.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
  
  def mark_for_export
    current_user.add_export_ids(params[:export_ids])
    current_user.remove_export_ids(params[:skip_ids])
    
    render json: current_user.ready_for_export
  end

  def queued
    respond_to do |format|
      format.json { render json: current_user.ready_for_export }
      format.html { redirect_to admin_opportunities_path }
    end
  end
  
  def unqueue
    current_user.remove_all_exports
    flash[:notice] = 'There are no more opportunties queued for export'

    redirect_to admin_opportunities_path
  end

  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
  end

  # GET /opportunities/new
  def new
    @opportunity = @opportunities.build
    @opportunity.tasks.build
    @opportunity.set_default_industries
  end

  # GET /opportunities/1/edit
  def edit
    @opportunity.tasks.build
  end

  # POST /opportunities
  # POST /opportunities.json
  def create
    @opportunity = @opportunities.build(opportunity_params)

    respond_to do |format|
      if @opportunity.save
        format.html { redirect_to admin_employer_opportunities_path(@opportunity.employer), notice: 'Opportunity was successfully created.' }
        format.json { render :show, status: :created, location: @opportunity }
      else
        format.html { render :new }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opportunities/1
  # PATCH/PUT /opportunities/1.json
  def update
    respond_to do |format|
      if @opportunity.update(opportunity_params)
        format.html { redirect_to admin_employer_opportunities_path(@opportunity.employer), notice: 'Opportunity was successfully updated.' }
        format.json { render :show, status: :ok, location: @opportunity }
      else
        format.html { render :edit }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def unpublish
    @opportunity.unpublish!
    redirect_to request.referer
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
    employer = @opportunity.employer
    @opportunity.destroy

    respond_to do |format|
      format.html { redirect_to admin_employer_opportunities_url(employer), notice: 'Opportunity was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_employer
    @employer = Employer.find(params[:employer_id]) if params[:employer_id]
    @opportunities = (@employer ? @employer.opportunities : Opportunity).paginate(page: params[:page])
    
    if params[:filter].blank?
      @opportunities = @opportunities.current
    else
      @opportunities = case params[:filter]
      when 'queued'
        @opportunities.ready_for_export(current_user)
      when 'expired', 'published', 'employer_partner', 'inbound', 'recurring'
        @opportunities.send(params[:filter])
      else
        @opportunities.current.where(region_id: params[:filter])
      end
    end
    
    @opportunities = if params[:sort] == 'recent'
      @opportunities.recent
    else
      @opportunities.prioritized
    end
  end
  
  def exportable_opportunities
    (@employer ? @employer.opportunities : Opportunity).ready_for_export(current_user).prioritized.sort_by{|o| o.application_deadline || 10.years.from_now}
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_opportunity
    @opportunity = @opportunities.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def opportunity_params
    params.require(:opportunity).permit(
      :_destroy,
      :name, :summary, :employer_id, :job_posting_url, :application_deadline, 
      :inbound, :recurring, :opportunity_type_id, :region_id, :how_to_apply, :referral_email,
      :industry_tags, :interest_tags, :metro_tags, :major_tags, :industry_interest_tags,
      steps: [],
      industry_ids: [], interest_ids: [], metro_ids: [], major_ids: [], location_ids: [],
      locations_attributes: [
        :_destroy, :id, :name, :locateable_id, :locateable_type,
        contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
      ]
    )
  end
end
