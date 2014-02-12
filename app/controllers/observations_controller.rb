# encoding: UTF-8
# Allows modification and viewing of observations
class ObservationsController < ApplicationController
  # ActionController::Parameters.action_on_unpermitted_parameters = :raise

#  before_filter :require_user, :except => [:index, :show, :related]
  # helper_method :observation
  respond_to :json, :html

  # GET /observations
  # GET /observations.xml
  def index
    obstype = ObservationType.find_by_id(params[:obstype])
    @observations = obstype.try(:observations) || Observation.all
    @observations = @observations.by_company(current_user.company) if signed_in?
    @observations = @observations.by_page(params[:page])

    respond_with @observations do |format|
      format.salus_xml { render 'index', :formats => [:salus_xml] }
      format.salus_csv { render 'index', :formats => [:salus_csv] }
    end
  end

  def show
    @observation = Observation.where(:id => params[:id]).includes(:person, :observation_types,
                                                                  {:activities => [:person,
                                                                    {:setups => [:equipment, 
                                                                      {:material_transactions => [:material, :unit]}]}]}).first
    @areas_as_text = @observation.areas_as_text
    respond_with @observation 
  end

  def new
    @observation = Observation.new
    @observation.obs_date = Date.today
    respond_with @observation
  end

  # POST /observations
  # POST /observations.xml
  def create
    user = current_user.person
    @observation = user.observations.new(observation_params)
    @observation.company = user.company
    logger.info user.name
    flash[:form] = @observation.save ? 'Observation was successfully created.' : "Creation failed"
    respond_with @observation
  end

  def edit
    @observation = Observation.by_company(current_user.company).where(:id => params[:id]).includes(:observation_types, {:activities => {:setups => :material_transactions}}).first
    respond_with @observation
  end

  def update
    @observation = Observation.where(:id => params[:id]).includes(:observation_types, {:activities => {:setups => :material_transactions}}).first
    p observation_params
    if @observation.update_attributes(observation_params)
      flash[:notice] = "Observation was successfully updated."
    end
    respond_with @observation
  end

  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy
    redirect_to observations_url
  end

  def related
    @observation = Observation.where(:id => params[:id]).includes(:areas => :observations).first
  end

  # def observation
  #   Observation.find(params[:id])
  # end

  private

  def observation_params

    params.require(:observation).permit(:observation_date, :comment, {observation_type_ids: []},
                                        :areas_as_text, 
                                        {activities_attributes: [{person: :id}, :hours, :id, :_destroy,
                                          {setups_attributes: [{equipment: [:id]}, :id, :_destroy, 
                                            {material_transactions_attributes: [:id, {material: :id}, :rate, 
                                              {unit: :id}, :_destroy]}] } ]})
  end
end
