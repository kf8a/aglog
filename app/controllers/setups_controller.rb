# These methods are most commonly called from the Edit Observation page to modify
# setups of an observation
class SetupsController < ApplicationController

  def create
    @setup = Setup.new(params[:setup])
    @setup.save
    render :nothing => true
  end

  def update
    @setup = Setup.find(params[:id])
    if @setup.update_attributes(params[:setup])
      flash[:activity] = "Setup was successfully updated."
    end
    render :nothing => true
  end

  def destroy
    @setup = Setup.find(params[:id])
    @setup.destroy
    render :nothing => true
  end
end
