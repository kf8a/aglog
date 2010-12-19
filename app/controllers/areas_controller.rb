class AreasController < ApplicationController

  # GET /areas
  # GET /areas.xml
  def index
    @observation = Observation.find_by_id(params[:observation_id])
    @areas = if @observation then @observation.areas.order('study_id, name') else Area.order('study_id, name') end
    respond_with @areas
  end
  
end