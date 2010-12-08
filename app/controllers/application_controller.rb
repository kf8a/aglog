# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_test_user if Rails.env == "test"
  before_filter :require_user, :except => [:index, :show]
    
  helper_method :current_user, :signed_in?

  protected

  def current_user
    @current_user ||= Person.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try(:id)
  end

  private
  def set_test_user
    @current_user = Person.first
  end

  def require_user
    unless signed_in?
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_person_session_url
      return false
    end
  end

  def require_no_user
    if signed_in?
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to observations_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
 
  def mark_for_deletion
    deleted_id = params[:id] 
    p deleted_id
    render :update do |page|
      page << "$('#{deleted_id}_deleted').value='true'"
      page.hide deleted_id
    end
  end
  
end