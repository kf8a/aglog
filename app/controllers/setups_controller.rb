class SetupsController < ApplicationController

  def new
    @activity = Activity.find_by_id(params[:activity_id])
    @setup = if @activity then @activity.setups.new else Setup.new end
  end

  def create
    @setup = Setup.new(params[:setup])
    @setup.save
    render :nothing => true
  end

  #This is most commonly called from the Edit Observation page
  def destroy
    @setup = Setup.find(params[:id])
    @setup.destroy
    render :nothing => true
  end
end
