class PersonSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  
  def new
    if params[:message] == "connection_failed"
      flash[:error] = "OpenId is unable to verify the credentials you provided."
    end
  end

  def create
    auth = request.env['omniauth.auth']
    if auth['provider'] == "open_id"
      openid = auth['uid']
      person = Person.find_by_openid_identifier(openid)
      if person
        self.current_user = person
        flash[:notice] = "Login successful!"
        redirect_back_or_default '/observations'
      else
        flash[:notice] = "No user exists with #{openid} as an open_id authentication."
        render :action => :new
      end
    else
      flash[:notice] = "Wrong provider - should be open_id"
      render :action => :new
    end

#    @person_session = PersonSession.new(params[:person_session])
#
#    @person_session.save do |result|
#      if result
#        flash[:notice] = "Login successful!"
#        redirect_back_or_default 'observation'
#      else
#        render :action => :new
#      end
#    end
  end

  def destroy
    self.current_user = nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_person_session_path
  end
  
end
