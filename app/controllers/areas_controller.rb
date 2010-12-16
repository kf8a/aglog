class AreasController < ApplicationController

  # GET /areas
  # GET /areas.xml
  def index
    @areas = Area.order('study_id, name')
    respond_with @areas
  end
  
end