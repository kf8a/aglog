# encoding: UTF-8
class ObservationsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :related]

  # GET /observations
  # GET /observations.xml
  def index
    state = if params[:in_review] then "in_review" else "published" end

    if params[:obstype]
       @observations = Observation.paginate :page=> params[:page], 
         :order => 'obs_date desc', 
         :conditions => ['state = ? and observation_type_id = ?', state, params[:obstype]], 
         :joins => 'join observation_types_observations on  observation_types_observations.observation_id = id'
     else
       @observations = Observation.paginate :page => params[:page], 
         :order => 'obs_date desc',
         :conditions => ['state = ?',state]
     end
 
    respond_to do |format|
      format.html #index.html
      format.xml  { render :xml => @observations.to_xml }
      format.salus_xml { render 'index.salus_xml' }
      format.salus_csv {render :text => Observation.to_salus_csv}
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
