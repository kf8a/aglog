require 'test_helper'

class SetupsControllerTest < ActionController::TestCase

  #TODO Write tests for non-signed-in-user

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "POST :create" do
      setup do
        @equipment = Factory.create(:equipment)
        post :create, :setup => { :equipment_id => @equipment.id }
      end
      
      should "create a setup" do
        refute_nil Setup.find_by_equipment_id(@equipment.id)
      end
    end

    context "POST :create with an activity" do
      setup do
        @activity = Factory.create(:activity)
        @equipment = Factory.create(:equipment)
        post :create, :setup => { :activity_id => @activity.id, :equipment_id => @equipment.id }
      end

      should "create a setup for that activity" do
        refute_nil Setup.find_by_activity_id_and_equipment_id(@activity.id, @equipment.id)
      end
    end

    context "DELETE :destroy a setup" do
      setup do
        @setup = Factory.create(:setup)
        delete :destroy, :id => @setup.id
      end

      should "delete the setup" do
        assert_nil Setup.find_by_id(@setup.id)
      end
    end

    #TODO Write tests for PUT update
  end

end
