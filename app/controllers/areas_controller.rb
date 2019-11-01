# frozen_string_literal: true

# Allows modification and viewing of areas
class AreasController < ApplicationController
  respond_to :html, :json

  def index
    query = params[:q]
    areas = Area.all

    @areas =
      if query
        areas.find_with_name_like(query).to_jquery_tokens
      else
        areas.roots
      end

    respond_with @areas
  end

  def show
    @area = Area.find(params[:id])
    @observations =
      @area.leaf_observations.sort { |a, b| b.obs_date <=> a.obs_date }

    respond_with @area
  end

  def new
    @area = Area.new
    respond_with @area
  end

  def create
    @area = Area.new(area_params)
    # @area.company = current_user.default_company
    if @area.save
      flash[:notice] = 'Area was successfully created.'
      respond_with @area
    else
      render :new
    end
  end

  def edit
    @area = Area.find(params[:id])
    respond_with @area
  end

  def update
    @area = Area.find(params[:id])
    if @area.update(area_params)
      respond_with @area
    else
      render :edit
    end
  end

  def destroy
    area = Area.find(params[:id])
    area.destroy
    redirect_to areas_url
  end

  private

  def companies
    current_user.companies
  end

  def area_params
    params.require(:area).permit(:name, :replicate, :study_id, :retired,
                                 :treatment_id, :company_ids, :description)
  end
end
