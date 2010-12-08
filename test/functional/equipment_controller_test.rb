require 'test_helper'

class EquipmentControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:equipment)
  end

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    should "get new" do
      get :new
      assert_response :success
    end
    
    should "create_equipment" do
      old_count = Equipment.count
      post :create, :equipment => { }
      assert_equal old_count+1, Equipment.count
      assert_redirected_to equipment_path(assigns(:equipment))
    end

    context "POST :create with invalid attributes" do
      setup do
        Factory.create(:equipment, :name => "Repeat_name")
        post :create, :equipment => { :name => "Repeat_name" }
      end

      should render_template :new
      should_not set_the_flash
    end

    context "POST :create in xml format" do
      setup do
        post :create,
             :format => 'xml',
             :equipment => { }
      end

      should respond_with(201)
      should respond_with_content_type(:xml)
    end

    context "An equipment exists. " do
      setup do
        @equipment = Factory.create(:equipment)
      end

      context "GET :show the equipment" do
        setup do
          get :show, :id => @equipment
        end

        should render_template 'show'
      end

      context "GET :edit the equipment" do
        setup do
          get :edit, :id => @equipment
        end

        should render_template 'edit'
      end

      context "PUT :update the equipment with valid attributes" do
        setup do
          put :update, :id => @equipment, :equipment => { }
        end

        should redirect_to("the show page for the equipment") {equipment_path(@equipment)}
      end

      context "PUT :update the equipment with invalid attributes" do
        setup do
          Factory.create(:equipment, :name => "Repeat_name")
          put :update, :id => @equipment, :equipment => { :name => "Repeat_name"}
        end

        should render_template :edit
      end

      context "DELETE :destroy the equipment" do
        setup do
          delete :destroy, :id => @equipment
        end

        should redirect_to("the equipment index page") {equipment_index_path}
        should "destroy the equipment" do
          assert_nil Equipment.find_by_id(@equipment)
        end
      end
    end
  end
  

  
end
