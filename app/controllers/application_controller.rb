# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml

  before_filter :authenticate_user!, :except => [:index, :show] unless Rails.env() == 'development'

  # layout :site_layout

  # protected

  # def authorized_text
  #   user_signed_in? ? "authorized" : "unauthorized"
  # end

  # def site_layout
  #   authorized_text
  # end
end
