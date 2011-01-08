# encoding: UTF-8
# Allows modification and viewing of observations
class ObservationsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :related]

  # GET /observations
  # GET /observations.xml
  def index
    state = if params[:in_review] then "in_review" else "published" end
    obstype, page = params[:obstype], params[:page]
    state_observations = Observation.where(:state => state).order('obs_date desc').includes({:areas => [:study, :treatment]}, :observation_types, {:activities => {:setups => {:material_transactions => :material}}})

    if obstype
      @observations = state_observations.paginate :page=> page,
        :conditions => ['observation_type_id = ?', obstype],
        :joins => 'join observation_types_observations on  observation_types_observations.observation_id = id'
    else
      @observations = state_observations.paginate :page => page
    end
 
    respond_to do |format|
      format.html #index.html
      format.xml  { render :xml => @observations.to_xml }
      format.salus_xml { render 'index.salus_xml' }
      format.salus_csv { render 'index.salus_csv' }
    end
  end

  def show
    @observation = Observation.where(:id => params[:id]).includes(:person, :observation_types, {:activities => [:person, {:setups => [:equipment, {:material_transactions => [{:material => :hazards}, :unit]}]}]}).first
    @areas_as_text = @observation.areas_as_text
    respond_with @observation
  end

  def new
    @observation = Observation.new
    respond_with @observation
  end

  # POST /observations
  # POST /observations.xml
  def create
    @observation = current_user.observations.new(params[:observation])
    logger.info current_user.name
    if @observation.save
      flash[:form] = 'Observation was successfully created.'
    else
      flash[:form] = "Creation failed"
    end
    respond_with @observation
  end

  def edit
    @observation = Observation.where(:id => params[:id]).includes(:observation_types, {:activities => {:setups => :material_transactions}}).first
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
