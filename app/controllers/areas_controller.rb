# Allows modification and viewing of areas
class AreasController < ApplicationController
  respond_to :html, :json

  def index
    query = params[:q]
    @areas = company.try(:areas) || Area.all

    @areas = 
      if query
        @areas.find_with_name_like(query).to_jquery_tokens
      else
        @areas.roots
      end

    respond_with @areas
  end

  def show
    @area = Area.find(params[:id])
    @observations = 
      @area.leaf_observations.sort { |a, b| b.obs_date <=> a.obs_date }

    respond_with @area
  end

  def move_to
    area = Area.find(params[:parent_id])
    child = Area.find(params[:id])
    child.move_to_child_of(area) unless child == area
    render partial: 'area', locals: { area: area }
  end

  def move_before
    area = Area.find(params[:parent_id])
    child = Area.find(params[:id])
    father = area.parent
    child.move_to_left_of(area) unless child == area

    if area.root?
      areas = company.try(:areas) || Area.scoped
      render partial: 'area_list', locals: { area_roots: areas.roots }
    else
      render partial: 'area', locals: { area: father }
    end
  end

  def new
    @area = Area.new
    respond_with @area
  end

  def create
    @area = Area.new(area_params)
    @area.company = company
    if @area.save
      flash[:notice] = 'Area was successfully created.'
      respond_with @area
    else
      render :new
    end
  end

  def edit
    @area = Area.by_company(company).find(params[:id])
    respond_with @area
  end

  def update
    @area = Area.by_company(company).find(params[:id])
    if @area.update_attributes(area_params)
      respond_with @area
    else
      render :edit
    end
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    redirect_to areas_url
  end

  private

  def company
    current_user.try(:company)
  end

  def area_params
    params.require(:area).permit(:name, :replicate, :study_id,
                                 :treatment_id, :description)
  end
end
