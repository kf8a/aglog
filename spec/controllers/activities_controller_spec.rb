require 'spec_helper'

describe ActivitiesController do
  render_views
  
  context "Signed in. " do
    before(:each) do
      sign_out
    end

    describe "POST :create" do
      before(:each) do
        @person = find_or_factory(:person)
        @prior_activities = @person.activities.count
        post :create, :activity => { :person_id => @person.id }
      end

      it "should not create an activity" do
        @person.reload
        @person.activities.count.should equal(@prior_activities)
      end

      it { should redirect_to new_person_session_path }
    end

    context "An activity exists. " do
      before(:each) do
        @activity = Factory.create(:activity)
      end

      describe "PUT :update the activity" do
        before(:each) do
          @new_person = Factory.create(:person, :sur_name => "Newguy")
          put :update, :id => @activity.id, :activity => { :person_id => @new_person.id }
        end

        it "should not update the activity" do
          @activity.reload
          @new_person.reload
          @activity.person.should_not be_eql(@new_person)
        end

        it { should redirect_to new_person_session_path }
      end

      describe "DELETE :destroy the activity" do
        before(:each) do
          delete :destroy, :id => @activity.id
        end

        it "should not delete the activity" do
          Activity.exists?(@activity.id).should be_true
        end

        it { should redirect_to new_person_session_path }
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
          @activity.reload
          @new_person.reload
          @activity.person.should be_eql(@new_person)
        end

        it { should set_the_flash }
      end

      describe 'PUT :update the activity with invalid attributes' do
        before(:each) do
          put :update, :id => @activity.id, :activity => { :person_id => nil }
        end

        it { should_not set_the_flash }
      end

      describe "DELETE :destroy an activity" do
        before(:each) do
          delete :destroy, :id => @activity.id
        end

        it "should delete the activity" do
          Activity.exists?(@activity.id).should be_false
        end
      end
    end
    
    describe "POST :create" do
      before(:each) do
        @person = find_or_factory(:person)
        @prior_activities = @person.activities.count
        post :create, :activity => { :person_id => @person.id }
      end

      it "should create an activity" do
        @person.reload
        @person.activities.count.should equal(@prior_activities + 1)
      end
    end
  end
end
