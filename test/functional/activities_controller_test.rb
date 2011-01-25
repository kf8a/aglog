require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  context "Not signed in. " do
    setup do
      sign_out
    end

    context "POST :create" do
      setup do
        @person = Factory.create(:person)
        post :create, :activity => { :person_id => @person.id }
      end

      should "not create an activity" do
        assert_nil Activity.find_by_person_id(@person.id)
      end

      should ("redirect to the sign in page"){ redirect_to new_person_session_url }
    end

    context "An activity exists. " do
      setup do
        @activity = Factory.create(:activity)
      end

      context "PUT :update the activity" do
        setup do
          @new_person = Factory.create(:person, :sur_name => "Newguy")
          put :update, :id => @activity.id, :activity => { :person_id => @new_person.id }
        end

        should "not update the activity" do
          assert_nil Activity.find_by_person_id(@new_person.id)
        end

        should ("redirect to the sign in page"){ redirect_to new_person_session_url }
      end

      context "DELETE :destroy an activity" do
        setup do
          delete :destroy, :id => @activity.id
        end

        should "not delete the activity" do
          assert Activity.find_by_id(@activity.id)
        end

        should ("redirect to the sign in page"){ redirect_to new_person_session_url }
      end
    end

  end

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "An activity exists. " do
      setup do
        @activity = Factory.create(:activity)
      end

      context "PUT :update the activity" do
        setup do
          @new_person = Factory.create(:person, :sur_name => "Newguy")
          put :update, :id => @activity.id, :activity => { :person_id => @new_person.id }
        end

        should "update the activity" do
          assert Activity.find_by_person_id(@new_person.id)
        end

        should set_the_flash
      end

      context 'PUT :update the activity with invalid attributes' do
        setup do
          put :update, :id => @activity.id, :activity => { :person_id => nil }
        end

        should_not set_the_flash
      end

      context "DELETE :destroy an activity" do
        setup do
          delete :destroy, :id => @activity.id
        end

        should "delete the activity" do
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
        assert Activity.find_by_person_id(@person.id)
      end
    end
  end
end
