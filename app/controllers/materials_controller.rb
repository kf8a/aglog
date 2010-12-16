class MaterialsController < ApplicationController
  
  # GET /materials
  # GET /materials.xml
  def index
    @materials = Material.find(:all, :order => 'material_type_id, name')
    respond_with @materials
  end
  
  # GET /materials/1/get_hazards
  def get_hazards
    @material = Material.find_by_id(params[:id]) || Material.new
  end
  
  # PUT /materials/1/put_hazards
  def put_hazards
    @material = Material.find_by_id(params[:id])
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

end