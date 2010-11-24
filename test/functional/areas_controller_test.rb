require 'test_helper'

class AreasControllerTest < ActionController::TestCase

  def setup
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:areas)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_area
    old_count = Area.count
    post :create, :area => { :name => 'T2R22' }
    assert_equal old_count+1, Area.count
    
    assert_redirected_to area_path(assigns(:area))
  end

  def test_should_show_area
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_area
    put :update, :id => 1, :area => { :name  => 'new_area'}
    assert_redirected_to area_path(assigns(:area))
  end
  
  def test_should_destroy_area
    old_count = Area.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Area.count
    
    assert_redirected_to areas_path
  end
end
