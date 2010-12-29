# Allows modification and viewing of hazards
class HazardsController < ApplicationController

  def index
    @hazards = Hazard.all
    respond_with @hazards
  end

  def show
    @hazard = Hazard.find(params[:id])
    respond_with @hazard
  end

  def new
    @hazard = Hazard.new
    respond_with @hazard
  end

  def edit
    @hazard = Hazard.find(params[:id])
    respond_with @hazard
  end

  def create
    @hazard = Hazard.new(params[:hazard])
    if @hazard.save
      flash[:notice] = 'Hazard was successfully created.'
    end
    respond_with @hazard
  end

  def update
    @hazard = Hazard.find(params[:id])
    if @hazard.update_attributes(params[:hazard])
      flash[:notice] = 'Hazard was successfully updated.'
    end
    respond_with @hazard
  end

  def destroy
    @hazard = Hazard.find(params[:id])
    @hazard.destroy
    respond_with @hazard
  end

end
