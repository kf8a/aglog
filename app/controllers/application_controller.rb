# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml
  
  before_filter :require_user, :except => [:index, :show]
    
  helper_method :current_user, :signed_in?

  def signed_in?
    !!current_user
  end

  # This is equivalent to the following code for each controller:
  # def index
  #   @areas = Area.all
  #   respond_with @areas
  # end
  def index
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name
    instance = model.all
    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  # This is equivalent to the following code for each controller:
  # def show
  #   @area = Area.find(params[:id])
  #   respond_with @area
  # end
  def show
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name.singularize
    instance = model.find(params[:id])
    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  #This is equivalent to the following code for each controller:
  # def new
  #   @hazard = Hazard.new
  #   respond_with @hazard
  # end
  def new
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name.singularize
    instance = model.new
    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  # This is equivalent to the following code for each controller:
  # def create
  #   @hazard = Hazard.new(params[:hazard])
  #   if @hazard.save
  #     flash[:notice] = "Hazard was successfully created."
  #   end
  #
  #   respond_with @hazard
  # end
  def create
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name.singularize
    symbol = model_name.to_sym
    instance = model.new(params[symbol])
    if instance.save
      flash[:notice] = "#{model_name.capitalize} was successfully created."
    end

    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  # This is equivalent to the following code for each controller:
  # def edit
  #   @area = Area.find(params[:id])
  #   respond_with @area
  # end
  def edit
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name.singularize
    instance = model.find(params[:id])
    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  # This is equivalent to the following code for each controller:
  # def update
  #   @area = Area.find(params[:id])
  #   @area.update_attributes(params[:area])
  #   if @area.update_attributes(params[:area])
  #     flash[:notice] = 'Area was successfully updated.'
  #   end
  #   respond_with @area
  # end
  def update
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name.singularize
    instance = model.find(params[:id])
    symbol = model_name.to_sym
    if instance.update_attributes(params[symbol])
      flash[:notice] = "#{model_name.capitalize} was successfully updated."
    end
    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  # This is equivalent to the following code for each controller:
  # def destroy
  #   @area = Area.find(params[:id])
  #   @area.destroy
  #   respond_with @area
  # end
  def destroy
    model = self.controller_name.singularize.capitalize.constantize
    model_name = self.controller_name.singularize
    instance = model.find(params[:id])
    instance.destroy
    instance_variable_set("@#{model_name}", instance)
    respond_with instance
  end

  protected

  def current_user
    @current_user ||= Person.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try(:id)
  end

  private

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