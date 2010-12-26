class MaterialsController < ApplicationController
  
  # GET /materials
  # GET /materials.xml
  def index
    @materials = Material.order('material_type_id, name')
    respond_with @materials
  end

  def show
    @material = Material.find(params[:id])
    respond_with @material
  end

  def edit
    @material = Material.find(params[:id])
    respond_with @material
  end

  def new
    @material = Material.new
    respond_with @material
  end

  def create
    @material = Material.new(params[:material])
    if @material.save
      flash[:notice] = 'Material was successfully created.'
    end
    respond_with @material
  end

  def update
    @material = Material.find(params[:id])
    if @material.update_attributes(params[:material])
      flash[:notice] = 'Material was successfully updated.'
    end
    respond_with @material
  end

  def destroy
    @material = Material.find(params[:id])
    @material.destroy
    respond_with @material
  end
  
  # GET /materials/1/get_hazards
  def get_hazards
    @material = Material.find_by_id(params[:id]) || Material.new
  end
  
  # PUT /materials/1/put_hazards
  def put_hazards
    @material = Material.find_by_id(params[:id])
    if @material
      haz = []

      if params[:hazards]
        vals = params[:hazards].values
        vals.each { |h| haz << Hazard.find(h) }
      end

      @material.hazards = haz

      redirect_to :action => "edit"
    else
      redirect_to :action => "new"
    end
	end
	
	# POST /materials/new_hazards
	def new_hazards
	
	end

end