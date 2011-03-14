# Allows modification and viewing of equipment
class EquipmentController < ApplicationController

  def index
    if current_user
      @equipment = Equipment.by_company(current_user.company)
    else
      @equipment = Equipment.order('name').all
    end

    respond_with @equipment do |format|
      format.html { render_by_authorization('index') }
    end
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
    @equipment.company = current_user.company
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
