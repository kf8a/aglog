require 'test_helper'

class MaterialsControllerTest < ActionController::TestCase

  def setup
    sign_in_as_normal_user
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

  context "POST :create with XML format" do
    setup do
      post :create, :material => { :name => 'xml_name' }, :format => 'xml'
    end

    should respond_with(201)
    should respond_with_content_type(:xml)
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
      @material_id = Material.last.id
      get :get_hazards, :id => @material_id
    end

    should render_template :get_hazards
    should assign_to(:material).with(@material_id)
  end

  context "GET :get_hazards with a material that does not exist" do
    setup do
      material_id = Material.last.id + 1
      assert_nil Material.find_by_id(material_id)
      get :get_hazards, :id => material_id
    end

    should render_template :get_hazards
    should "return a new material object" do
      assert assigns(:material).new_record?
    end
  end

  context "PUT :put_hazards with a valid material id" do
    setup do
      @material_id = Material.last.id
      put :put_hazards, :id => @material_id
    end

    should redirect_to("the edit material page") {edit_material_path(@material_id)}
  end

  context "PUT :put_hazards with invalid material id" do
    setup do
      material_id = Material.last.id + 1
      put :put_hazards, :id => material_id
    end

    should redirect_to("the new material page") {new_material_path}
  end

end
