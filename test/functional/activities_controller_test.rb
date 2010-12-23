require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  context "Not signed in. " do
    setup do
      sign_out
    end

    #TODO Write tests for non-signed-in-user
  end

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "An activity exists. " do
      setup do
        @activity = Factory.create(:activity)
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

    #TODO Write tests for PUT :update
  end
end
