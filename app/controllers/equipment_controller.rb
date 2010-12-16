class EquipmentController < ApplicationController

  # GET /equipment
  # GET /equipment.xml
  def index
    @equipment = Equipment.order('name')
    respond_with @equipment
  end
  
end