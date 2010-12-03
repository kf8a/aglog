class UnitsController < ApplicationController
  before_filter :get_unit, :only => [:show, :edit, :update, :destroy]
  respond_to :html, :xml

  def new
  	@unit = Unit.new
    respond_with @unit
  end

	# GET /units/1;edit
  def edit
  	respond_with @unit
  end

	# GET /units/1
	# GET /units/1.xml
  def show
    respond_with @unit
  end

	# GET /units
	# GET /units.xml
  def index
  	@units = Unit.find(:all)
    respond_with @units
  end
  
  # POST /units
  # POST /units.xml
  def create
    @unit = Unit.new(params[:unit])
    if @unit.save
      flash[:notice] = 'Unit was successfully created.'
    end
    respond_with @unit
  end

	# PUT /units/1
	# PUT /units/1.xml
	def update
		@unit.update_attributes(params[:unit])
    respond_with @unit
  end
  
  # DELETE /units/1
  # DELETE /units/1.xml
  def destroy
    @unit.destroy
    respond_with @unit
  end

  private ####################

  def get_unit
    @unit = Unit.find(params[:id])
  end
  
end