class AreasController < ApplicationController
  # GET /areas
  # GET /areas.xml
  def index
    @areas = Area.find(:all,  :order => 'study_id, name')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @areas.to_xml }
    end
  end
  
  # GET /areas/1
  # GET /areas/1.xml
  def show
    @area = Area.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @area.to_xml }
    end
  end
  
  # GET /areas/new
  def new
    @area = Area.new
  end
  
  # GET /areas/1;edit
  def edit
    @area = Area.find(params[:id])
  end

  # POST /areas
  # POST /areas.xml
  def create
    @area = Area.new(params[:area])
    
    respond_to do |format|
      if @area.save
        flash[:notice] = 'Area was successfully created.'
        
        format.html { redirect_to area_url(@area) }
        format.xml do
          headers["Location"] = area_url(@area)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @area.errors.to_xml }
      end
    end
  end
  
  # PUT /areas/1
  # PUT /areas/1.xml
  def update
    @area = Area.find(params[:id])
    
    respond_to do |format|
      if @area.update_attributes(params[:area])
        format.html { redirect_to area_url(@area) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @area.errors.to_xml }        
      end
    end
  end
  
  # DELETE /areas/1
  # DELETE /areas/1.xml
  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    
    respond_to do |format|
      format.html { redirect_to areas_url   }
      format.xml  { render :nothing => true }
    end
  end
end