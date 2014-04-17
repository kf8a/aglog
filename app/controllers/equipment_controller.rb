# Allows modification and viewing of equipment
class EquipmentController < ApplicationController

  def index
    if current_user
      @equipment = Equipment.by_company(current_user.company).ordered
    else
      @equipment = Equipment.ordered
    end

    respond_with @equipment
  end

  def show
    @equipment = Equipment.where(:id => params[:id]).includes(:setups => {:observation => :observation_types}).first
    @equipment_pictures = @equipment.equipment_pictures.load
    respond_with @equipment
  end

  def new
    @equipment = Equipment.new
    @equipment_pictures = @equipment.equipment_pictures.build
  end

  def create
    @equipment = Equipment.new(equipment_params)
    @equipment.company = current_user.company
    if @equipment.save
      pictures = params[:equipment_pictures]
      if pictures
        pictures['equipment_picture'].each do |picture|
          @equipment_picture = @equipment.equipment_pictures.create(equipment_picture: picture, equipment_id: @equipment.id)
        end
      end
      flash[:notice] = 'Equipment was successfully created.'
    end
    respond_with @equipment
  end

  def edit
    @equipment = Equipment.by_company(current_user.company).find(params[:id])
    if @equipment.equipment_pictures.empty?
      @equipment_pictures = @equipment.equipment_pictures.build
    end
    respond_with @equipment
  end

  def update
    @equipment = Equipment.by_company(current_user.company).find(params[:id])
    if @equipment.update(equipment_params)
      pictures = params[:equipment_pictures]
      if pictures
        pictures['equipment_picture'].each do |picture|
          @equipment_picture = @equipment.equipment_pictures.create(equipment_picture: picture, equipment_id: @equipment.id)
        end
      end
    end
    respond_with @equipment
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    respond_with @equipment
  end

  private

  def equipment_params
    params.require(:equipment).permit(:name, :use_material, :is_tractor, :description,
                                     :archived)
  end
end
