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
       @observations =  Observation.paginate :page => params[:page], :order => 'obs_date desc', :conditions => ['state = ?',state]
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

  # POST  /observations/add_activity
  def add_activity
    observation = params[:id].empty? ? Observation.new(params[:observation]) : Observation.find(params[:id])

    observation.set_activities(params[:activities])

    observation.activities << Activity.new
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace'activities',  :partial => 'activity',  :locals => {:observation  => observation}
        end
      end
    end
  end

  # POST /observations/add_setup?activity_index=y
  def add_setup
    observation = params[:id].empty? ? Observation.new(params[:observation]) : Observation.find(params[:id])

    observation.set_activities(params[:activities])

    activity  =  observation.activities[params[:activity_index].to_i]
    activity.setups  <<  Setup.new
    respond_to do |format|
      format.js  do
        render :update do |page|
          page.replace 'activities',  :partial => 'activity', :locals => {:observation => observation}
        end
      end
    end
  end

  # POST /observations/add_material?activity_index=x&setup_index=y
  def add_material
    observation = params[:id].empty? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    
    observation.set_activities(params[:activities])

    activity =  observation.activities[params[:activity_index].to_i]
    setup = activity.setups[params[:setup_index].to_i]
    setup.material_transactions << MaterialTransaction.new

    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'activities', :partial => 'activity',  :locals => {:observation => observation}
        end
      end
    end
  end
  
  def delete_material
    observation = params[:id].empty? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    observation.set_activities(params[:activities])
    
    activity = observation.activities[params[:activity_index].to_i]
    setup = activity.setups[params[:setup_index].to_i]
    material_transaction = setup.material_transactions[params[:material_index].to_i]
    setup.material_transactions.delete(material_transaction)
    
    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'activities', :partial => 'activity',  :locals => {:observation => observation}
        end
      end
    end
  end

	def delete_setup
	  observation = params[:id].empty? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    observation.set_activities(params[:activities])
    
    activity = observation.activities[params[:activity_index].to_i]
    setup = activity.setups[params[:setup_index].to_i]
    
    activity.setups.delete(setup)
		    
    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'activities', :partial => 'activity',  :locals => {:observation => observation}
        end
      end
    end
	end
	
	def delete_activity
	  observation = params[:id].empty? ? Observation.new(params[:observation]) : Observation.find(params[:id])
    observation.set_activities(params[:activities])
    
    activity = observation.activities[params[:activity_index].to_i]
    observation.activities.delete(activity)
    
    respond_to  do |format|
      format.js do
        render :update do |page|
          page.replace 'activities', :partial => 'activity',  :locals => {:observation => observation}
        end
      end
    end
  end
      
  #   
  # GET /observations/1;edit
  def edit
    @observation = Observation.find(params[:id])
  end

  # POST /observations
  # POST /observations.xml
  def create
    @observation = Observation.new(params[:observation])    
    @observation.set_activities(params[:activities])

    logger.info current_user.name
    @observation.person_id = current_user.id

    respond_to do |format|
      if @observation.save
        flash[:notice] = 'Observation was successfully created.'

        format.html { redirect_to observation_url(@observation) }
        format.xml do
          headers["Location"] = observation_url(@observation)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @observation.errors.to_xml }
      end
    end
  end

  # PUT /observations/1
  # PUT /observations/1.xml
  def update    
    @observation = Observation.find(params[:id])
    @observation.set_activities(params[:activities])

    respond_to do |format|
      if @observation.update_attributes(params[:observation])
        flash[:notice] = " observation saved"

        format.html { redirect_to observation_url(@observation) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @observation.errors.to_xml }        
      end
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

  private

end