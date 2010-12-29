# encoding: UTF-8
# Allows modification and viewing of observations
class ObservationsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :related]

  # GET /observations
  # GET /observations.xml
  def index
    state = if params[:in_review] then "in_review" else "published" end
    state_observations = Observation.where(:state => state).order('obs_date desc')

    if params[:obstype]
       @observations = state_observations.paginate :page=> params[:page],
         :conditions => ['observation_type_id = ?', params[:obstype]], 
         :joins => 'join observation_types_observations on  observation_types_observations.observation_id = id'
     else
       @observations = state_observations.paginate :page => params[:page]
     end
 
    respond_to do |format|
      format.html #index.html
      format.xml  { render :xml => @observations.to_xml }
      format.salus_xml { render 'index.salus_xml' }
      format.salus_csv { render 'index.salus_csv' }#:text => Observation.to_salus_csv}
    end
  end

  def show
    @observation = Observation.find(params[:id])
    respond_with @observation
  end

  def new
    @observation = Observation.new
    respond_with @observation
  end

  # POST /observations
  # POST /observations.xml
  def create
    @observation = Observation.new(params[:observation])
    logger.info current_user.name
    @observation.person_id = current_user.id
    if @observation.save
      flash[:form] = 'Observation was successfully created.'
    else
      flash[:form] = "Creation failed"
    end
    respond_with @observation
  end

  def edit
    @observation = Observation.find(params[:id])
    respond_with @observation
  end

  def update
    @observation = Observation.find(params[:id])
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
    @observation = Observation.find(params[:id])
    @areas = @observation.areas
  end

end
