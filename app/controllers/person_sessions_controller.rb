# This controller deals with logging in and out
class PersonSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def index
   if current_user
     @person = Person.by_company(current_user.company).order('sur_name')
   else
     @person = Person.all.order('sur_name')
   end 
  end


  def new
    if params[:message] == "connection_failed"
      flash[:error] = "OpenId is unable to verify the credentials you provided."
    end
  end

  def create
    auth = request.env['omniauth.auth']
    if auth['provider'] == "open_id"
      open_id_session auth['uid']
    else
      flash[:notice] = "Wrong provider - should be open_id"
      render :new
    end
  end

  def destroy
    self.current_user = nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_person_session_path
  end

  private

  def open_id_session(openid)
    person = Person.find_by_openid_identifier(openid)
    if person.present?
      self.current_user = person
      flash[:notice] = "Login successful!"
      redirect_back_or_default '/observations'
    else
      flash[:notice] = "No user exists with #{openid} as an open_id authentication."
      render :new
    end
  end

end
