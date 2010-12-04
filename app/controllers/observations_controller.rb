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
    if params[:commit] == "Create Observation" || params[:commit] == ""
      @observation = Observation.new(params[:observation])
      @observation.set_activities(params[:activities])
      logger.info current_user.name
      @observation.person_id = current_user.id
      if @observation.save
        flash[:form] = 'Observation was successfully created.'
      else
        flash[:form] = "Creation failed"
      end
    else
      update_activity
    end

    respond_with_javascript
  end

  # PUT /observations/1
  # PUT /observations/1.xml
  def update
    if params[:commit] == "Update Observation" || params[:commit] == ""
      @observation = Observation.find(params[:id])
      @observation.set_activities(params[:activities])
      if @observation.update_attributes(params[:observation])
        flash[:form] = "Observation Updated!"
      else
        flash[:form] = "Update failed"
      end
    else
      update_activity
    end

    respond_with_javascript
  end

  # DELETE /observations/1
  # DELETE /observations/1.xml
  def destroy
    @observation.destroy
    respond_with @observation
  end

  private #############################

  def get_observation
    @observation = Observation.find(params[:id])
  end

  def update_activity
    prepare_observation

    activity_index = params[:activity_index]
    setup_index = params[:setup_index]
    material_index = params[:material_index]

    case params[:commit]
    when "add activity"
      @observation.add_activity
    when "delete activity"
      @observation.delete_activity(activity_index)
    when "add setup"
      @observation.add_setup(activity_index)
    when "delete setup"
      @observation.delete_setup(activity_index, setup_index)
    when "add material"
      @observation.add_material(activity_index, setup_index)
    when "delete material"
      @observation.delete_material(activity_index, setup_index, material_index)
    end
  end

  def prepare_observation
    @observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    @observation.set_activities(params[:activities])
  end

  def respond_with_javascript
    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => @observation}
        end
      end
    end
  end

end