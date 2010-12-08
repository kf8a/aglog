require 'test_helper'

class UnitsControllerTest < ActionController::TestCase

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end
    
    context "GET :new" do
      setup do
        get :new
      end

      should respond_with :success
      should render_template :new
    end

    context "GET :index" do
      setup do
        get :index
      end

      should respond_with :success
      should render_template :index
    end

    context "POST :create with valid parameters" do
      setup do
        post :create, :unit => {:name => "test_name"}
      end

      should set_the_flash.to(:notice => "Unit was successfully created.")
      should redirect_to("the created unit's page") {unit_path(assigns(:unit))}
    end

    context "POST :create with invalid parameters" do
      setup do
        repeat_name = Unit.first.name
        post :create, :unit => {:name => repeat_name}
      end

      should_not set_the_flash
      should render_template :new
    end

    context "POST :create in XML format" do
      setup do
        post :create, :unit => { :name => 'xml_name' }, :format => 'xml'
      end

      should respond_with(201)
      should respond_with_content_type(:xml)
    end

    context "A unit exists. " do
      setup do
        @unit = Factory.create(:unit)
      end

      context "GET :edit the unit" do
        setup do
          get :edit, :id => @unit.id
        end

        should respond_with :success
        should assign_to(:unit).with(@unit)
        should render_template :edit
      end

      context "GET :show the unit" do
        setup do
          get :show, :id => @unit.id
        end

        should respond_with :success
        should assign_to(:unit).with(@unit)
        should render_template :show
      end

      context "PUT :update the unit with valid attributes" do
        setup do
          put :update, :id => @unit.id, :unit => {:name => "different_name"}
        end

        should assign_to(:unit).with(@unit)
        should redirect_to("the created unit's page") {unit_path(assigns(:unit))}
      end

      context "PUT :update the unit with invalid attributes" do
        setup do
          Factory.create(:unit, :name => "repeat_name")
          put :update, :id => @unit.id, :unit => {:name => "repeat_name"}
        end

        should assign_to(:unit).with(@unit)
        should render_template :edit
      end

      context "DELETE :destroy the unit" do
        setup do
          delete :destroy, :id => @unit.id
        end

        should assign_to(:unit).with(@unit)
        should redirect_to("the units index page") {units_path}
      end
    end
  end
end