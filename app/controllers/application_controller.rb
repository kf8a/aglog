# Filters added to this controller will be run for all controllers
# in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  respond_to :html, :xml

  before_action :authenticate_user!, except: [:index, :show]
end
