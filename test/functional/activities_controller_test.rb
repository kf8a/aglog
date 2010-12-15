require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "GET :index" do
      setup do
        get :index
      end

      should render_template 'index'
    end

    context "GET :index with an observation" do
      setup do
        @observation = Factory.create(:observation)
        @another_observation = Factory.create(:observation)
        @activity_1 = Factory.create(:activity, :observation_id => @observation.id)
        @activity_2 = Factory.create(:activity, :observation_id => @observation.id)
        @another_activity = Factory.create(:activity, :observation_id => @another_observation.id)

        get :index, :observation_id => @observation.id
      end

      should render_template 'index'
      should "include only the activities that belong to that observation" do
        assert assigns(:activities).include?(@activity_1)
        assert assigns(:activities).include?(@activity_2)
        refute assigns(:activities).include?(@another_activity)
      end
    end

    context "GET :new" do
      setup do
        get :new
      end

      should render_template 'new'
    end

    context "GET :new with an observation" do
      setup do
        @observation = Factory.create(:observation)
        get :new, :observation_id => @observation.id
      end

      should render_template 'new'
      should "make an activity that is part of that observation" do
        assert_equal @observation, assigns(:activity).observation
      end
    end

    context "An activity exists. " do
      setup do
        @activity = Factory.create(:activity)
      end

      context "GET :show the activity" do
        setup do
          get :show, :id => @activity.id
        end

        should render_template 'show'
      end

      context "DELETE :destroy an activity" do
        setup do
          delete :destroy, :id => @activity.id
        end

        should "delete the setup" do
          assert_nil Activity.find_by_id(@activity.id)
        end
      end
    end
    

    context "POST :create" do
      setup do
        @person = Factory.create(:person)
        post :create, :activity => { :person_id => @person.id }
      end

      should "create an activity" do
        refute_nil Activity.find_by_person_id(@person.id)
      end
    end

    context "POST :create with an observation" do
      setup do
        @observation = Factory.create(:observation)
        @person = Factory.create(:person)
        post :create, :activity => { :observation_id => @observation.id, :person_id => @person.id }
      end

      should "create a setup for that activity" do
        refute_nil Activity.find_by_observation_id_and_person_id(@observation.id, @person.id)
      end
    end
  end
end
