# Allows modification and viewing of units
class UnitsController < ApplicationController

  def index
    @units = Unit.ordered
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
    @unit = Unit.new(unit_params)
    if @unit.save
      flash[:notice] = 'Unit was successfully created.'
    end
    respond_with @unit
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update_attributes(unit_params)
      flash[:notice] = 'Unit was successfully updated.'
    end
    respond_with @unit
  end

  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    respond_with @unit
  end

  private

  # attr_accessible :name, :si_unit_id, :conversion_factor
  def unit_params
    params.require(:unit).permit(:name, :si_unit_id, :conversion_factor)
  end
end
