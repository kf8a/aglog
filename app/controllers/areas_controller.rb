class AreasController < ApplicationController

  def index
    @observation = Observation.find_by_id(params[:observation_id])
    @areas = if @observation then @observation.areas.order('study_id, name') else Area.order('study_id, name') end
    respond_with @areas
  end

  def show
    @area = Area.find(params[:id])
    respond_with @area
  end

  def new
    @area = Area.new
    respond_with @area
  end

  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:notice] = 'Area was successfully created.'
    end
    respond_with @area
  end

  def edit
    @area = Area.find(params[:id])
    respond_with @area
  end

  def update
    @area = Area.find(params[:id])
    @area.update_attributes(params[:area])
    respond_with @area
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    respond_with @area
  end

end