require 'spec_helper'

describe UnitsController do
  render_views
  
  describe "Signed in as a normal user. " do
    before(:each) do
      sign_in_as_normal_user
    end

    describe "GET :new" do
      before(:each) do
        get :new
      end

      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "GET :index" do
      before(:each) do
        get :index
      end

      it { should respond_with :success }
      it { should render_template :index }
    end

    describe "POST :create with valid parameters" do
      before(:each) do
        post :create, :unit => {:name => "test_name"}
      end

      it { should set_the_flash.to(:notice => "Unit was successfully created.") }
      it { should redirect_to unit_path(assigns(:unit)) }
    end

    describe "POST :create with invalid parameters" do
      before(:each) do
        repeat_name = Unit.first.name
        post :create, :unit => {:name => repeat_name}
      end

      it { should_not set_the_flash }
      it { should render_template :new }
    end

    describe "POST :create in XML format" do
      before(:each) do
        post :create, :unit => { :name => 'xml_name' }, :format => 'xml'
      end

      it { should respond_with(201) }
      it { should respond_with_content_type(:xml) }
    end

    describe "A unit exists. " do
      before(:each) do
        @unit = Factory.create(:unit)
      end

      describe "GET :edit the unit" do
        before(:each) do
          get :edit, :id => @unit.id
        end

        it { should respond_with :success }
        it { should assign_to(:unit).with(@unit) }
        it { should render_template :edit }
      end

      describe "GET :show the unit" do
        before(:each) do
          get :show, :id => @unit.id
        end

        it { should respond_with :success }
        it { should assign_to(:unit).with(@unit) }
        it { should render_template :show }
      end

      describe "PUT :update the unit with valid attributes" do
        before(:each) do
          put :update, :id => @unit.id, :unit => {:name => "different_name"}
        end

        it { should assign_to(:unit).with(@unit) }
        it { should redirect_to unit_path(assigns(:unit)) }
      end

      describe "PUT :update the unit with invalid attributes" do
        before(:each) do
          Factory.create(:unit, :name => "repeat_name")
          put :update, :id => @unit.id, :unit => {:name => "repeat_name"}
        end

        it { should assign_to(:unit).with(@unit) }
        it { should render_template :edit }
      end

      describe "DELETE :destroy the unit" do
        before(:each) do
          delete :destroy, :id => @unit.id
        end

        it { should assign_to(:unit).with(@unit) }
        it { should redirect_to units_path }
      end
    end
  end
end

