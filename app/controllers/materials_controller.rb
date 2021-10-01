# frozen_string_literal: true

# Allows modification and viewing of materials
class MaterialsController < ApplicationController
  respond_to :json, :html # GET /materials.xml
  def index
    company = current_user.try(:company)
    broad_scope = company ? Material.by_company(company) : Material.current
    @materials = broad_scope.order('material_type_id, name').includes(:material_type)

    respond_with @materials
  end

  def show
    @material = Material.find_with_children(params[:id])
    respond_with @material
  end

  def edit
    @material = Material.by_company(current_user.companies).find(params[:id])
    respond_with @material
  end

  def new
    @material = Material.new
    respond_with @material
  end

  def create
    @material = Material.new(material_params)
    @material.company = current_user.default_company
    flash[:notice] = 'Material was successfully created.' if @material.save
    respond_with @material
  end

  def update
    @material = Material.find(params[:id])
    if @material.update(material_params)
      flash[:notice] = 'Material was successfully updated.'
      respond_with @material
    else
      render :edit
    end
  end

  def destroy
    @material = Material.find(params[:id])
    @material.destroy
    redirect_to materials_url
  end

  private

  def material_params
    params.require(:material).permit(:name,
                                     :operation_type_id, :material_type_id,
                                     :n_content, :p_content, :k_content,
                                     :specific_weight, :salus_code,
                                     :liquid, :archived)
  end
end
