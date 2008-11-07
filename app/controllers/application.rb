# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include Authenticated
  
  before_filter :login_required, :except => [:index, :show]
 
  def mark_for_deletion
    deleted_id = params[:id] 
    p deleted_id
    render :update do |page|
      page << "$('#{deleted_id}_deleted').value='true'"
      page.hide deleted_id
    end
  end
  
end