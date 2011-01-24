require 'test_helper'

class SetupsControllerTest < ActionController::TestCase

  context "Not signed in. " do
    setup do
      sign_out
    end

    context "POST :create" do
      setup do
        @equipment = Factory.create(:equipment)
        @setup_count = Setup.count
        post :create, :setup => { :equipment_id => @equipment.id }
      end

      should "not create a setup" do
        assert_equal @setup_count, Setup.count
      end
    end

    context "POST :create with an activity" do
      setup do
        @activity = Factory.create(:activity)
        @equipment = Factory.create(:equipment)
        post :create, :setup => { :activity_id => @activity.id, :equipment_id => @equipment.id }
      end

      should "not create a setup for that activity" do
        assert_nil Setup.find_by_activity_id_and_equipment_id(@activity.id, @equipment.id)
      end
    end

    context "DELETE :destroy a setup" do
      setup do
        @setup = Factory.create(:setup)
        delete :destroy, :id => @setup.id
      end

      should "not delete the setup" do
        assert Setup.find_by_id(@setup.id)
      end
    end

    context "PUT :update a setup" do
      setup do
        @setup = Factory.create(:setup)
        @new_equipment = Factory.create(:equipment)
        put :update, :id => @setup.id, :setup => { :equipment_id => @new_equipment.id }
      end

      should "not update the setup" do
        @setup.reload
        assert @setup.equipment != @new_equipment
      end
    end
  end

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "POST :create" do
      setup do
        @equipment = Factory.create(:equipment)
        @setup_count = Setup.count
        post :create, :setup => { :equipment_id => @equipment.id }
      end
      
      should "create a setup" do
        assert_equal @setup_count + 1, Setup.count
      end
    end

    context "POST :create with an activity" do
      setup do
        @activity = Factory.create(:activity)
        @equipment = Factory.create(:equipment)
        @setup_count = @activity.setups.count
        post :create, :setup => { :activity_id => @activity.id, :equipment_id => @equipment.id }
      end

      should "create a setup for that activity" do
        @activity.reload
        assert_equal @setup_count + 1, @activity.setups.count
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

    context "PUT :update a setup" do
      setup do
        @setup = Factory.create(:setup)
        @new_equipment = Factory.create(:equipment)
        put :update, :id => @setup.id, :setup => { :equipment_id => @new_equipment.id }
      end

      should "update the setup" do
        @setup.reload
        assert_equal @setup.equipment, @new_equipment
      end
    end
  end
end
