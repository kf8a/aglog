class ActivitiesController < ApplicationController

  def create
    @activity = Activity.new(params[:activity])
    @activity.save
    render :nothing => true
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      flash[:activity] = "Activity was successfully updated."
    end
    render :nothing => true
  end
  
  #This is most commonly called from the Edit Observation page
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    render :nothing => true
  end

end
