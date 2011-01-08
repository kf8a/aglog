# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml

  before_filter :require_user, :except => [:index, :show]
    
  helper_method :current_user, :signed_in?

  layout :site_layout

  def signed_in?
    !!current_user
  end

  protected

  def site_layout
    if current_user then "authorized" else "unauthorized" end
  end

  def current_user
    @current_user ||= Person.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try(:id)
  end

  private

  def model_name
    self.controller_name.singularize
  end

  def model
    model_name.capitalize.constantize
  end

  def require_user
    unless signed_in?
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_person_session_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
 
end