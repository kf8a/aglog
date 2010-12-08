class AuthenticationsController < ApplicationController
  def index
    @authentications = Authentication.all
  end
  
  def create
    @authentication = Authentication.new(params[:authentication])
    if @authentication.save
      flash[:notice] = "Successfully created authentication."
      redirect_to authentications_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
