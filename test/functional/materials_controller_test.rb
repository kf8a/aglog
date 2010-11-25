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

  context "POST :create with invalid attributes" do
    setup do
      Factory.create(:material, :name => "repeat_name")
      post :create, :material => { :name => "repeat_name" }
    end

    should render_template :new
    should_not set_the_flash
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

  context "PUT :update with invalid attributes" do
    setup do
      Factory.create(:material, :name => "repeat_name")
      put :update, :id => 1, :material => { :name => "repeat_name" }
    end

    should render_template :edit
  end
  
  def test_should_destroy_material
    old_count = Material.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Material.count
    
    assert_redirected_to materials_path
  end

  context "GET :get_hazards with a material that exists" do
    setup do
      material_id = Material.last.id
      get :get_hazards, :id => material_id
    end

    should render_template :get_hazards
    should assign_to(:material).with(Material.last)
  end

  context "GET :get_hazards with a material that does not exist" do
    setup do
      material_id = Material.last.id + 1
      get :get_hazards, :id => material_id
    end

    should render_template :get_hazards
    should "return a new material object" do
      assert assigns(:material).new_record?
    end
  end

end
