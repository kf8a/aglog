require 'spec_helper'

describe PersonSessionsController do
  render_views
  
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

