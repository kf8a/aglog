# encoding: UTF-8
class ObservationsController < ApplicationController
  # GET /observations
  # GET /observations.xml
  def index
    if params[:in_review]
      state = 'in_review'
    else
      state  = 'published'
    end
    
    @observations_total = Observation.count();
    if params[:obstype]
       @observations = Observation.paginate :page=> params[:page], 
         :order => 'obs_date desc', 
         :conditions => ['state = ? and observation_type_id = ?', state, params[:obstype]], 
         :joins => 'join observation_types_observations on  observation_types_observations.observation_id = id'
     else
       @observations =  Observation.paginate :page => params[:page], 
         :order => 'obs_date desc',
         :conditions => ['state = ?',state]
     end
 
#    @observations = Observation.find(:all, :order => 'obs_date desc', :conditions => ['state = ?',state])
    
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
    @observation = Observation.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @observation.to_xml }
      format.csv  { render :csv => @observation.to_csv }
    end
  end

  # GET /observations/new
  def new
    @observation = Observation.new
   end

  #   
  # GET /observations/1;edit
  def edit
    @observation = Observation.find(params[:id])
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

      respond_to  do |format|
        format.js do
          render :update do |page|
            page.replace 'observation_form', :partial => 'form', :locals => {:observation => @observation}
          end
        end
      end
    else
      update_activity
    end
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

      respond_to  do |format|
        format.js do
          render :update do |page|
            page.replace 'observation_form', :partial => 'form', :locals => {:observation => @observation}
          end
        end
      end
    else
      update_activity
    end
  end

  # DELETE /observations/1
  # DELETE /observations/1.xml
  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy

    respond_to do |format|
      format.html { redirect_to observations_url   }
      format.xml  { render :nothing => true }
    end
  end

  private #############################

  def update_activity
    case params[:commit]
    when "add activity"
      add_activity
    when "delete activity"
      delete_activity
    when "add setup"
      add_setup
    when "delete setup"
      delete_setup
    when "add material"
      add_material
    when "delete material"
      delete_material
    end
  end

    # POST  /observations/add_activity
  def add_activity
    observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])

    observation.set_activities(params[:activities])

    observation.activities << Activity.new

    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => observation}
        end
      end
    end
  end

  # POST /observations/add_setup?activity_index=y
  def add_setup
    observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])

    observation.set_activities(params[:activities])

    activity  =  observation.activities[params[:activity_index].to_i]
    activity.setups  <<  Setup.new

    activity.save
    observation.save

    respond_to do |format|
      format.js  do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => observation}
        end
      end
    end
  end

  # POST /observations/add_material?activity_index=x&setup_index=y
  def add_material
    observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])

    observation.set_activities(params[:activities])

    activity =  observation.activities[params[:activity_index].to_i]
    setup = activity.setups[params[:setup_index].to_i]
    setup.material_transactions << MaterialTransaction.new
    setup.save
    activity.save
    observation.save

    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => observation}
        end
      end
    end
  end

  def delete_material
    observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    observation.set_activities(params[:activities])

    activity = observation.activities[params[:activity_index].to_i]
    setup = activity.setups[params[:setup_index].to_i]
    material_transaction = setup.material_transactions[params[:material_index].to_i]
    setup.material_transactions.delete(material_transaction)

    setup.save
    activity.save
    observation.save

    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => observation}
        end
      end
    end
  end

	def delete_setup
	  observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    observation.set_activities(params[:activities])

    activity = observation.activities[params[:activity_index].to_i]
    setup = activity.setups[params[:setup_index].to_i]

    activity.setups.delete(setup)

    activity.save
    observation.save

    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => observation}
        end
      end
    end
	end

	def delete_activity
	  observation = params[:id].blank? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    observation.set_activities(params[:activities])

    activity = observation.activities[params[:activity_index].to_i]
    observation.activities.delete(activity)

    activity.save
    observation.save

    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'observation_form', :partial => 'form', :locals => {:observation => observation}
        end
      end
    end
  end
end