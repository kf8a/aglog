require 'spec_helper'

describe SetupsController do
  render_views
  
  describe "Not signed in. " do
    before(:each) do
      sign_out
    end

    describe "POST :create" do
      before(:each) do
        @equipment = find_or_factory(:equipment)
        @setup_count = Setup.count
        post :create, :setup => { :equipment_id => @equipment.id }
      end

      it "should not create a setup" do
        assert_equal @setup_count, Setup.count
      end
    end

    describe "POST :create with an activity" do
      before(:each) do
        @activity = Factory.create(:activity)
        @equipment = find_or_factory(:equipment)
        post :create, :setup => { :activity_id => @activity.id, :equipment_id => @equipment.id }
      end

      it "should not create a setup for that activity" do
        assert_nil Setup.find_by_activity_id_and_equipment_id(@activity.id, @equipment.id)
      end
    end

    describe "DELETE :destroy a setup" do
      before(:each) do
        @setup = Factory.create(:setup)
        delete :destroy, :id => @setup.id
      end

      it "should not delete the setup" do
        assert Setup.find_by_id(@setup.id)
      end
    end

    describe "PUT :update a setup" do
      before(:each) do
        @setup = Factory.create(:setup)
        @new_equipment = find_or_factory(:equipment, :name => 'brand new equipment')
        put :update, :id => @setup.id, :setup => { :equipment_id => @new_equipment.id }
      end

      it "should not update the setup" do
        @setup.reload
        assert @setup.equipment != @new_equipment
      end
    end
  end

  describe "Signed in as a normal user. " do
    before(:each) do
      sign_in_as_normal_user
    end

    describe "POST :create" do
      before(:each) do
        @equipment = find_or_factory(:equipment)
        @setup_count = Setup.count
        post :create, :setup => { :equipment_id => @equipment.id }
      end

      it "should create a setup" do
        assert_equal @setup_count + 1, Setup.count
      end
    end

    describe "POST :create with an activity" do
      before(:each) do
        @activity = Factory.create(:activity)
        @equipment = find_or_factory(:equipment)
        @setup_count = @activity.setups.count
        post :create, :setup => { :activity_id => @activity.id, :equipment_id => @equipment.id }
      end

      it "should create a setup for that activity" do
        @activity.reload
        assert_equal @setup_count + 1, @activity.setups.count
      end
    end

    describe "DELETE :destroy a setup" do
      before(:each) do
        @setup = Factory.create(:setup)
        delete :destroy, :id => @setup.id
      end

      it "should delete the setup" do
        assert_nil Setup.find_by_id(@setup.id)
      end
    end

    describe "PUT :update a setup" do
      before(:each) do
        @setup = Factory.create(:setup)
        @new_equipment = find_or_factory(:equipment, :name => 'new equipment')
        put :update, :id => @setup.id, :setup => { :equipment_id => @new_equipment.id }
      end

      it "should update the setup" do
        @setup.reload
        assert_equal @setup.equipment, @new_equipment
      end
    end
  end
end

