# Allows modification and viewing of materials
class MaterialsController < ApplicationController
  
  # GET /materials
  # GET /materials.xml
  def index
    @materials = Material.order('material_type_id, name').includes(:material_type).all
    respond_with @materials
  end

  def show
    @material = Material.where(:id => params[:id]).includes(:hazards, :material_transactions, :setups => {:observation => :observation_types}).first
    respond_with @material
  end

  def edit
    @material = Material.find(params[:id])
    @hazards = @material.hazards.all
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
    @hazards = @material.hazards.all
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
    @current_hazards = @material.hazards.all
  end
  
  # PUT /materials/1/put_hazards
  def put_hazards
    @material = Material.find_by_id(params[:id])
    if @material
      values = params[:hazards].try(:values).to_a # If nil, we get []
      @material.hazards = values.collect { |value| Hazard.find(value) }
      
      redirect_to :action => "edit"
    else
      redirect_to :action => "new"
    end
	end
	
	# POST /materials/new_hazards
	def new_hazards
	
	end

end