# Allows modification and viewing of areas
class AreasController < ApplicationController

  respond_to :html, :json

  def index
    company = current_user.try(:company)
    observation_id = params[:observation_id]
    query = params[:q]

    if query
      @areas =
        if company
          Area.by_company(company).find_with_name_like(query)
        else
          Area.find_with_name_like(query)
        end
        @areas = @areas.collect {|x| {:id=>x.id, :name=>x.name}}
    else
      @areas =
        if company
          Area.roots.by_company(company)
#          Area.index_areas_by_company_and_observation(company, observation_id)
        else
#          Area.index_areas(observation_id)
          Area.roots
        end
    end

    respond_with @areas
  end

  def show
    @area = Area.find(params[:id])
    @observations = @area.observations.includes(
        :observation_types,
        {:setups => [:equipment,
                    {:material_transactions => [:material, :unit]}]}).all

    respond_with @area
  end

  def query
    company = current_user.try(:company)
    respond_with @areas
  end

  def move_to
    area= Area.find(params[:parent_id])
    child = Area.find(params[:id])
    child.move_to_child_of(area)
    render :partial =>'area', :locals => {:area => area}
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

  def check_parsing
    @areas = Area.check_parse(params[:areas_as_text])
    render :text => @areas
  end

end
