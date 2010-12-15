class ActivitiesController < ApplicationController
  before_filter :get_observation
  respond_to :html, :xml

  def index
    @activities = if @observation then @observation.activities else Activity.all end
  end
  
  def show
    @activity = Activity.find(params[:id])
  end
  
  def new
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

  private ##########################

  def get_observation
    @observation = Observation.find_by_id(params[:observation_id])
  end
end
