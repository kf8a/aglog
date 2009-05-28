class PersonSessionsController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  
  def new
    @person_session = PersonSession.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
     
    @person_session.save do |result|
      if result
        flash[:notice] = "Login successful!"
        redirect_back_or_default 'observation'
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_person_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_person_sessions_url
  end
  
end
