require 'spec_helper'

describe ActivitiesController do
  render_views
  
  describe "Not signed in. " do
    before(:each) do
      sign_out
    end

    describe "POST :create" do
      before(:each) do
        @person = Factory.create(:person)
        post :create, :activity => { :person_id => @person.id }
      end

      it "should not create an activity" do
        assert_nil Activity.find_by_person_id(@person.id)
      end

      it "should redirect to the sign in page" do
        should redirect_to new_person_session_url
      end
    end

    describe "An activity exists. " do
      before(:each) do
        @activity = Factory.create(:activity)
      end

      describe "PUT :update the activity" do
        before(:each) do
          @new_person = Factory.create(:person, :sur_name => "Newguy")
          put :update, :id => @activity.id, :activity => { :person_id => @new_person.id }
        end

        it "should not update the activity" do
          assert_nil Activity.find_by_person_id(@new_person.id)
        end

        it "should redirect to the sign in page" do
          should redirect_to new_person_session_url
        end
      end

      describe "DELETE :destroy an activity" do
        before(:each) do
          delete :destroy, :id => @activity.id
        end

        it "should not delete the activity" do
          assert Activity.find_by_id(@activity.id)
        end

        it "should redirect to the sign in page" do
          should redirect_to new_person_session_url
        end
      end
    end
  end

  describe "Signed in as a normal user. " do
    before(:each) do
      sign_in_as_normal_user
    end

    describe "An activity exists. " do
      before(:each) do
        @activity = Factory.create(:activity)
      end

      describe "PUT :update the activity" do
        before(:each) do
          @new_person = Factory.create(:person, :sur_name => "Newguy")
          put :update, :id => @activity.id, :activity => { :person_id => @new_person.id }
        end

        it "should update the activity" do
          assert Activity.find_by_person_id(@new_person.id)
        end

        it "should set the flash" do
          should set_the_flash
        end
      end

      describe 'PUT :update the activity with invalid attributes' do
        before(:each) do
          put :update, :id => @activity.id, :activity => { :person_id => nil }
        end

        it "should not set the flash" do
          should_not set_the_flash
        end
      end

      describe "DELETE :destroy an activity" do
        before(:each) do
          delete :destroy, :id => @activity.id
        end

        it "should delete the activity" do
          assert_nil Activity.find_by_id(@activity.id)
        end
      end
    end
    
    describe "POST :create" do
      before(:each) do
        @person = Factory.create(:person)
        post :create, :activity => { :person_id => @person.id }
      end

      it "should create an activity" do
        assert Activity.find_by_person_id(@person.id)
      end
    end
  end
end
