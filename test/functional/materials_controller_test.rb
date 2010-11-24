require 'test_helper'

class MaterialsControllerTest < ActionController::TestCase

  def setup
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:materials)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_material
    old_count = Material.count
    post :create, :material => { }
    assert_equal old_count+1, Material.count
    
    assert_redirected_to material_path(assigns(:material))
  end

  def test_should_show_material
    get :show, :id => 15
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 2
    assert_response :success
  end
  
  def test_should_update_material
    put :update, :id => 1, :material => { }
    assert_redirected_to material_path(assigns(:material))
  end
  
  def test_should_destroy_material
    old_count = Material.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Material.count
    
    assert_redirected_to materials_path
  end
end
