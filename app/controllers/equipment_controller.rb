class EquipmentController < ApplicationController
  before_filter :get_equipment, :only => [:show, :edit, :update, :destroy]
  respond_to :html, :xml

  # GET /equipment
  # GET /equipment.xml
  def index
    @equipment = Equipment.find(:all, :order=>:name)
    respond_with @equipment
  end
  
  # GET /equipment/1
  # GET /equipment/1.xml
  def show
    respond_with @equipment
  end
  
  # GET /equipment/new
  def new
    @equipment = Equipment.new
  end
  
  # GET /equipment/1;edit
  def edit
    respond_with @equipment
  end

  # POST /equipment
  # POST /equipment.xml
  def create
    @equipment = Equipment.new(params[:equipment])
    if @equipment.save
      flash[:notice] = 'Equipment was successfully created.'
    end
    respond_with @equipment
  end
  
  # PUT /equipment/1
  # PUT /equipment/1.xml
  def update
    @equipment.update_attributes(params[:equipment])
    respond_with @equipment
  end
  
  # DELETE /equipment/1
  # DELETE /equipment/1.xml
  def destroy
    @equipment.destroy
    respond_with @equipment
  end

  private ####################

  def get_equipment
    @equipment = Equipment.find(params[:id])
  end
end