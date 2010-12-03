class HazardsController < ApplicationController
  before_filter :get_hazard, :only => [:show, :edit, :update, :destroy]
  respond_to :html, :xml

  # GET /hazards
  # GET /hazards.xml
  def index
    @hazards = Hazard.find(:all)
    respond_with @hazards
  end

  # GET /hazards/1
  # GET /hazards/1.xml
  def show
    respond_with @hazard
  end

  # GET /hazards/new
  # GET /hazards/new.xml
  def new
    @hazard = Hazard.new
    respond_with @hazard
  end

  # GET /hazards/1/edit
  def edit
    respond_with @hazard
  end

  # POST /hazards
  # POST /hazards.xml
  def create
    @hazard = Hazard.new(params[:hazard])
    if @hazard.save
      flash[:notice] = 'Hazard was successfully created.'
    end
    respond_with @hazard
  end

  # PUT /hazards/1
  # PUT /hazards/1.xml
  def update
    if @hazard.update_attributes(params[:hazard])
      flash[:notice] = 'Hazard was successfully updated.'
    end
    respond_with @hazard
  end

  # DELETE /hazards/1
  # DELETE /hazards/1.xml
  def destroy
    @hazard.destroy
    respond_with @hazard
  end

  private ############################

  def get_hazard
    @hazard = Hazard.find(params[:id])
  end
end
