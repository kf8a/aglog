require 'test_helper'

class PersonSessionsControllerTest < ActionController::TestCase

  context "GET :new" do
    setup do
      get :new
    end

    should render_template 'new'
  end

  context "GET :new with failed connection" do
    setup do
      get :new, :message => "connection_failed"
    end

    should render_template 'new'
    should set_the_flash
  end

  context "A user is logged in. " do
    setup do
      sign_in_as_normal_user
      assert @controller.signed_in?
    end

    context "DELETE :destory the session" do
      setup do
        delete :destroy
      end

      should "log out the user" do
        assert !@controller.signed_in?
      end
    end
  end
end
