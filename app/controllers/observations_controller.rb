# encoding: UTF-8
# Allows modification and viewing of observations
class ObservationsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :related]

  # GET /observations
  # GET /observations.xml
  def index
    state = params[:in_review] ? "in_review" : "published"
    obstype = ObservationType.find_by_id(params[:obstype])
    broad_scope = obstype.try(:observations) || Observation
    if current_user
      @observations = broad_scope.by_company(current_user.company).by_state_and_page(state, params[:page])
    else
      @observations = broad_scope.by_state_and_page(state, params[:page])
    end

    respond_with @observations do |format|
      format.salus_xml { render 'index.salus_xml' }
      format.salus_csv { render 'index.salus_csv' }
    end
  end

  def show
    @observation = Observation.where(:id => params[:id]).includes(:person, :observation_types, 
                                                                  {:activities => [:person, 
                                                                    {:setups => [:equipment, {:material_transactions => [{:material => :hazards}, :unit]}]}]}).first
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
    @observation = current_user.observations.new(params[:observation])
    @observation.company = current_user.company
    logger.info current_user.name
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

end
