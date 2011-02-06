require 'spec_helper'

describe PersonSessionsController do
  render_views
  
  describe "GET :new" do
    before(:each) do
      get :new
    end

    it { should render_template 'new' }
  end

  describe "GET :new with failed connection" do
    before(:each) do
      get :new, :message => "connection_failed"
    end

    it { should render_template 'new' }
    it { should set_the_flash }
  end

  describe "A user is logged in. " do
    before(:each) do
      sign_in_as_normal_user
      assert @controller.signed_in?
    end

    describe "DELETE :destory the session" do
      before(:each) do
        delete :destroy
      end

      it "should log out the user" do
        assert !@controller.signed_in?
      end
    end
  end
end

