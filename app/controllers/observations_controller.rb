# encoding: UTF-8
class ObservationsController < ApplicationController
  before_filter :get_observation, :only => [:show, :edit, :destroy]
  respond_to :html, :xml

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
      format.xml  { render :xml => @observations.to_xml(:include => [:areas]) }
      format.salus_xml { render :xml => Observation.to_salus_xml}
      format.salus_csv {render :text => Observation.to_salus_csv}
    end
  end

  # GET /observations/1
  # GET /observations/1.xml
  def show
    respond_with @observation
  end

  # GET /observations/new
  def new
    @observation = Observation.new
    respond_with @observation
   end

  #   
  # GET /observations/1;edit
  def edit
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

  # PUT /observations/1
  # PUT /observations/1.xml
  def update
    @observation = Observation.find(params[:id])
    @observation.set_activities(params[:activities])
    if @observation.update_attributes(params[:observation])
      flash[:form] = "Observation Updated!"
    else
      flash[:form] = "Update failed"
    end
    respond_with @observation
  end

  # DELETE /observations/1
  # DELETE /observations/1.xml
  def destroy
    @observation.destroy
    respond_with @observation
  end

  private #############################

  def get_observation
    @observation = Observation.find_by_id(params[:id])
  end

end
