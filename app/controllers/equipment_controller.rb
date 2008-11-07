class EquipmentController < ApplicationController
  # GET /equipment
  # GET /equipment.xml
  def index
    @equipment = Equipment.find(:all, :order=>:name)
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @equipment.to_xml }
    end
  end
  
  # GET /equipment/1
  # GET /equipment/1.xml
  def show
    @equipment = Equipment.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @equipment.to_xml }
    end
  end
  
  # GET /equipment/new
  def new
    @equipment = Equipment.new
  end
  
  # GET /equipment/1;edit
  def edit
    @equipment = Equipment.find(params[:id])
  end

  # POST /equipment
  # POST /equipment.xml
  def create
    @equipment = Equipment.new(params[:equipment])
    
    respond_to do |format|
      if @equipment.save
        flash[:notice] = 'Equipment was successfully created.'
        
        format.html { redirect_to equipment_url(@equipment) }
        format.xml do
          headers["Location"] = equipment_url(@equipment)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @equipment.errors.to_xml }
      end
    end
  end
  
  # PUT /equipment/1
  # PUT /equipment/1.xml
  def update
    @equipment = Equipment.find(params[:id])
    
    respond_to do |format|
      if @equipment.update_attributes(params[:equipment])
        format.html { redirect_to equipment_url(@equipment) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @equipment.errors.to_xml }        
      end
    end
  end
  
  # DELETE /equipment/1
  # DELETE /equipment/1.xml
  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    
    respond_to do |format|
      format.html { redirect_to equipment_url   }
      format.xml  { render :nothing => true }
    end
  end
end