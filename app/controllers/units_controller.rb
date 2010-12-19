class UnitsController < ApplicationController

  def index
    @units = Unit.all
    respond_with @units
  end

  def show
    @unit = Unit.find(params[:id])
    respond_with @unit
  end

  def new
    @unit = Unit.new
    respond_with @unit
  end

  def edit
    @unit = Unit.find(params[:id])
    respond_with @unit
  end

  def create
    @unit = Unit.new(params[:unit])
    if @unit.save
      flash[:notice] = 'Unit was successfully created.'
    end
    respond_with @unit
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update_attributes(params[:unit])
      flash[:notice] = 'Unit was successfully updated.'
    end
    respond_with @unit
  end

  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    respond_with @unit
  end

end