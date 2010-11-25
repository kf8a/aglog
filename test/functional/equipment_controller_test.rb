require 'test_helper'

class EquipmentControllerTest < ActionController::TestCase

  def setup
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:equipment)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_equipment
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

  def test_should_show_equipment
    get :show, :id => 6
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_equipment
    put :update, :id => 1, :equipment => { }
    assert_redirected_to equipment_path(assigns(:equipment))
  end
  
  context "PUT :update with invalid attributes" do
    setup do
      Factory.create(:equipment, :name => "Repeat_name")
      put :update, :id => 1, :equipment => { :name => "Repeat_name"}
    end
    
    should render_template :edit
  end
  
  def test_should_destroy_equipment
    old_count = Equipment.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Equipment.count
    
    assert_redirected_to equipment_path
  end
end
