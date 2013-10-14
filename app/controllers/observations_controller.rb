# encoding: UTF-8
# Allows modification and viewing of observations
class ObservationsController < ApplicationController
#  before_filter :require_user, :except => [:index, :show, :related]
  helper_method :observation
  respond_to :json, :html

  # GET /observations
  # GET /observations.xml
  def index
    obstype = ObservationType.find_by_id(params[:obstype])
    @observations = obstype.try(:observations) || Observation.scoped
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
                                                                      {:material_transactions => [{:material => :hazards}, :unit]}]}]}).first
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
    @observation = user.observations.new(params[:observation])
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
    if @observation.update_attributes(params[:observation])
      flash[:notice] = "Observation was successfully updated."
    end
    respond_with @observation
  end

  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy
    respond_with @observation
  end

  def related
    @observation = Observation.where(:id => params[:id]).includes(:areas => :observations).first
  end

  def observation
    Observation.find(params[:id])
  end

end
