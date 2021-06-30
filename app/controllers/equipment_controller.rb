# frozen_string_literal: true

# Allows modification and viewing of equipment
class EquipmentController < ApplicationController
  respond_to :json, :html

  def index
    @equipment = current_user ? equipment.ordered : Equipment.ordered

    respond_with @equipment
  end

  def show
    @equipment = Equipment.where(id: params[:id]).includes(setups: { observation: :observation_types }).first
    @equipment_pictures = @equipment.equipment_pictures.load
    respond_with @equipment
  end

  def new
    @equipment = Equipment.new
    @equipment_pictures = @equipment.equipment_pictures.build
  end

  def create
    @equipment = Equipment.new(equipment_params)
    @equipment.company = current_user.default_company
    if @equipment.save
      update_pictures
      flash[:notice] = 'Equipment was successfully created.'
    end
    respond_with @equipment
  end

  def edit
    @equipment = equipment
    @equipment_pictures = @equipment.equipment_pictures.build if @equipment.equipment_pictures.empty?
    respond_with @equipment
  end

  def update
    @equipment = equipment
    if @equipment.update(equipment_params)
      update_pictures
      respond_with @equipment
    else
      render :edit
    end
  end

  def destroy
    @equipment = equipment
    @equipment.equipment_pictures.each(&:destroy)
    @equipment.destroy
    redirect_to equipment_index_path
  end

  private

  def equipment_params
    params.require(:equipment).permit(
      :name,
      :use_material,
      :is_tractor,
      :description,
      :non_msu,
      :archived,
      :company_id,
      equipment_pictures_attributes: {}
    )
  end

  def update_pictures
    pictures = params[:equipment_pictures]
    return unless pictures

    pictures['equipment_picture'].each do |picture|
      @equipment_picture = @equipment.equipment_pictures.create(picture: picture, equipment_id: @equipment.id)
    end
  end

  def equipment
    if params[:id]
      # Equipment.by_company(current_user.companies).find(params[:id])
      Equipment.by_company(1).find(params[:id])
    else
      Equipment.by_company(1)
    end
  end
end
