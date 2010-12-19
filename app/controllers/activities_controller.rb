class ActivitiesController < ApplicationController

  def index
    @observation = Observation.find_by_id(params[:observation_id])
    @activities = if @observation then @observation.activities else Activity.all end
  end

  def show
    @activity = Activity.find(params[:id])
  end
  
  def new
    @observation = Observation.find_by_id(params[:observation_id])
    @activity = if @observation then @observation.activities.new else Activity.new end
  end
  
  def create
    @activity = Activity.new(params[:activity])
    @activity.save
    respond_with @activity
  end
  
  #This is most commonly called from the Edit Observation page
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    render :nothing => true
  end

end
