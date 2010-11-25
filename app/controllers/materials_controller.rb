class MaterialsController < ApplicationController
  
  # GET /materials
  # GET /materials.xml
  def index
    @materials = Material.find(:all, :order => 'material_type_id, name')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @materials.to_xml }
    end
  end
  
  # GET /materials/1
  # GET /materials/1.xml
  def show
    @material = Material.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @material.to_xml }
    end
  end
  
  # GET /materials/new
  def new
    @material = Material.new
  end
  
  # GET /materials/1;edit
  def edit
    @material = Material.find(params[:id])
  end

  # POST /materials
  # POST /materials.xml
  def create
    @material = Material.new(params[:material])
    
    respond_to do |format|
      if @material.save
        flash[:notice] = 'Material was successfully created.'
        
        format.html { redirect_to material_url(@material) }
        format.xml do
          headers["Location"] = material_url(@material)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @material.errors.to_xml }
      end
    end
  end
  
  # PUT /materials/1
  # PUT /materials/1.xml
  def update
    @material = Material.find(params[:id])
    
    respond_to do |format|
      if @material.update_attributes(params[:material])
        format.html { redirect_to material_url(@material) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @material.errors.to_xml }        
      end
    end
  end
  
  # DELETE /materials/1
  # DELETE /materials/1.xml
  def destroy
    @material = Material.find(params[:id])
    @material.destroy
    
    respond_to do |format|
      format.html { redirect_to materials_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  # GET /materials/1/get_hazards
  def get_hazards
  	if Material.find(:first, :conditions => "id = #{params[:id]}")
    	@material = Material.find(params[:id])
    else
  		@material = Material.new
  	end
  end
  
  # PUT /materials/1/put_hazards
  def put_hazards
	  	@material = Material.find(params[:id])
		
		haz = []
		vals = params[:hazards].values
		vals.each { |h| haz << Hazard.find(h) }
			
		if !params[:hazards].nil?
			@material.hazards = haz
		else	
			@material.hazards = nil
		end
		
		if !params[:id].nil?
			redirect_to :action => "edit"
		else
			redirect_to :action => "new"
		end
	end
	
	# POST /materials/new_hazards
	def new_hazards
	
	end
end