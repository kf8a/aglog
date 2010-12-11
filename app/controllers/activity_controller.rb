class ActivityController < ApplicationController

  def index
    observation = Observation.find_by_id(params[:observation_id])
    @activities = if observation then observation.activities else Activity.all
  end
  
  def show
    @activity = Activity.find(:id)
  end
  
  def new
    @activity = Activity.new
  end
  
  def create
    @activity = Activity.new(params[:activity])
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
end
