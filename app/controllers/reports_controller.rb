# Allows modification and viewing of reports
class ReportsController < ApplicationController

  def index
    current = session[:current_order]
    order = case params[:order]
     when 'date'
       by_date_desc == current ? by_date : by_date_desc
     when 'plot'
       by_area_name_desc == current ? by_area_name : by_area_name_desc
     when 'material'
       by_material_name_desc == current ? by_material_name : by_material_name_desc
     else
       by_date
     end
     
     session[:current_order] = order

     @transactions = MaterialTransaction.includes(:material, :unit, :setup => {:activity => :observation}).find_fertilizations(order)

     respond_to do |format|
       format.html 
     end
  end


  private #############

  def by_date
    'obs_date, areas.name, materials.name'
  end

  def by_date_desc
    'obs_date desc, areas.name, materials.name'
  end

  def by_area_name
    'areas.name, obs_date desc, materials.name'
  end

  def by_area_name_desc
    'areas.name desc, obs_date desc, materials.name'
  end

  def by_material_name
    'materials.name, obs_date desc, areas.name'
  end

  def by_material_name_desc
    'materials.name desc, obs_date desc, areas.name'
  end
end
