class MaterialsController < ApplicationController
  before_filter :get_material, :only => [:show, :edit, :update, :destroy, :put_hazards]
  respond_to :html, :xml
  
  # GET /materials
  # GET /materials.xml
  def index
    @materials = Material.find(:all, :order => 'material_type_id, name')
    respond_with @materials
  end
  
  # GET /materials/1
  # GET /materials/1.xml
  def show
    respond_with @material
  end
  
  # GET /materials/new
  def new
    @material = Material.new
  end
  
  # GET /materials/1;edit
  def edit
    respond_with @material
  end

  # POST /materials
  # POST /materials.xml
  def create
    @material = Material.new(params[:material])
    if @material.save
      flash[:notice] = 'Material was successfully created.'
    end
    respond_with @material
  end
  
  # PUT /materials/1
  # PUT /materials/1.xml
  def update
    @material.update_attributes(params[:material])
    respond_with @material
  end
  
  # DELETE /materials/1
  # DELETE /materials/1.xml
  def destroy
    @material.destroy
    respond_with @material
  end
  
  # GET /materials/1/get_hazards
  def get_hazards
    @material = Material.find_by_id(params[:id]) || Material.new
  end
  
  # PUT /materials/1/put_hazards
  def put_hazards
    if @material.nil?
      redirect_to :action => "new"
    else
      haz = []

      if !params[:hazards].nil?
        vals = params[:hazards].values
        vals.each { |h| haz << Hazard.find(h) }
      end

      @material.hazards = haz

      redirect_to :action => "edit"
    end
	end
	
	# POST /materials/new_hazards
	def new_hazards
	
	end

  private ####################

  def get_material
    @material = Material.find_by_id(params[:id])
  end
end