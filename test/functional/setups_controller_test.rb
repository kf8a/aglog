require 'test_helper'

class SetupsControllerTest < ActionController::TestCase

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "GET :new" do
      setup do
        get :new
      end

      should render_template 'new'
    end

    context "GET :new with an activity" do
      setup do
        @activity = Factory.create(:activity)
        get :new, :activity_id => @activity.id
      end

      should render_template 'new'
      should "make a setup that is part of that activity" do
        assert_equal @activity, assigns(:setup).activity
      end
    end
  end

end
