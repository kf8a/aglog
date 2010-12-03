class AreasController < ApplicationController
  before_filter :get_area, :only => [:show, :edit, :update, :destroy]
  respond_to :html, :xml

  # GET /areas
  # GET /areas.xml
  def index
    @areas = Area.order('study_id, name')
    respond_with @areas
  end
  
  # GET /areas/1
  # GET /areas/1.xml
  def show
    respond_with @area
  end
  
  # GET /areas/new
  def new
    @area = Area.new
    respond_with @area
  end
  
  # GET /areas/1;edit
  def edit
    respond_with @area
  end

  # POST /areas
  # POST /areas.xml
  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:notice] = 'Area was successfully created.'
    end
    respond_with @area
  end
  
  # PUT /areas/1
  # PUT /areas/1.xml
  def update
    @area.update_attributes(params[:area])
    respond_with @area
  end
  
  # DELETE /areas/1
  # DELETE /areas/1.xml
  def destroy
    @area.destroy
    respond_with @area
  end

  private ###################

  def get_area
    @area = Area.find(params[:id])
  end
end