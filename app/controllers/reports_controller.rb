class ReportsController < ApplicationController

  def index
    order = case params[:order]
     when 'date'
       session[:current_order] == 'obs_date desc, areas.name, materials.name' ? 'obs_date, areas.name, materials.name' : 'obs_date desc, areas.name, materials.name'
     when 'plot'
       session[:current_order] == 'areas.name desc, obs_date desc, materials.name' ? 'areas.name, obs_date desc, materials.name' : 'areas.name desc, obs_date desc, materials.name'
     when 'material'
       session[:current_order] == 'materials.name desc, obs_date desc, areas.name' ? 'materials.name, obs_date desc, areas.name' : 'materials.name desc, obs_date desc, areas.name'
     else
         'obs_date desc, areas.name, materials.name'
     end
     
     session[:current_order] = order

     @transactions = MaterialTransaction.find_fertilizations(order)

     respond_to do |format|
       format.html 
     end
  end
end
