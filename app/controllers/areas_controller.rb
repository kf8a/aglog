# Allows modification and viewing of areas
class AreasController < ApplicationController

  def index
    observation = Observation.find_by_id(params[:observation_id])
    broad_scope = observation.try(:areas) || Area
    if current_user
      @areas = broad_scope.by_company(current_user.company).order('study_id, name').includes(:study).all
    else
      @areas = broad_scope.order('study_id, name').includes(:study).all
    end

    respond_with @areas do |format|
      format.html { render_by_authorization('index') }
    end
  end

  def show
    @area = Area.find(params[:id])
    @observations = @area.observations.includes(
        :observation_types,
        {:setups => [:equipment,
                    {:material_transactions => [:material, :unit]}]}).all

    respond_with @area do |format|
      format.html { render_by_authorization('show') }
    end
  end

  def new
    @area = Area.new
    respond_with @area
  end

  def create
    @area = Area.new(params[:area])
    @area.company = current_user.company
    if @area.save
      flash[:notice] = 'Area was successfully created.'
    end
    respond_with @area
  end

  def edit
    @area = Area.by_company(current_user.company).find(params[:id])
    respond_with @area
  end

  def update
    @area = Area.by_company(current_user.company).find(params[:id])
    @area.update_attributes(params[:area])
    respond_with @area
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    respond_with @area
  end

end
