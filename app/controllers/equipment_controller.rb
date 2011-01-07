# Allows modification and viewing of equipment
class EquipmentController < ApplicationController

  def index
    @equipment = Equipment.order('name').all
    respond_with @equipment
  end

  def show
    @equipment = Equipment.where(:id => params[:id]).includes(:setups => {:observation => :observation_types}).first
    respond_with @equipment
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(params[:equipment])
    if @equipment.save
      flash[:notice] = 'Equipment was successfully created.'
    end
    respond_with @equipment
  end

  def edit
    @equipment = Equipment.find(params[:id])
    respond_with @equipment
  end

  def update
    @equipment = Equipment.find(params[:id])
    @equipment.update_attributes(params[:equipment])
    respond_with @equipment
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    respond_with @equipment
  end

end