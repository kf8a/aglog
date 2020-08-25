# frozen_string_literal: true

# Allows modification and viewing of units
class UnitsController < ApplicationController
  respond_to :json, :html

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
    flash[:notice] = 'Unit was successfully created.' if @unit.save
    respond_with @unit
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update_attributes(unit_params)
      flash[:notice] = 'Unit was successfully updated.'
      respond_with @unit
    else
      render :edit
    end
  end

  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    redirect_to units_url # respond_with @unit
  end

  private

  def unit_params
    params.require(:unit).permit(:name, :si_unit_id, :conversion_factor, :is_si_unit)
  end
end
