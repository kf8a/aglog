require 'spec_helper'

describe MaterialsController do
  render_views

  before(:each) do
    sign_in_as_normal_user
  end

  it "should get index" do
    get :index
    assert_response :success
    assert assigns(:materials)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create material" do
    old_count = Material.count
    assert !Material.exists?(:name => 'NewName')
    post :create, :material => { :name => 'NewName' }
    assert_equal old_count+1, Material.count

    assert_redirected_to material_path(assigns(:material))
  end

  describe "POST :create with invalid attributes" do
    before(:each) do
      Factory.create(:material, :name => "repeat_name")
      post :create, :material => { :name => "repeat_name" }
    end

    it { should render_template :new }
    it { should_not set_the_flash }
  end

  describe "POST :create with XML format" do
    before(:each) do
      post :create, :material => { :name => 'xml_name' }, :format => 'xml'
    end

    it { should respond_with(201) }
    it { should respond_with_content_type(:xml) }
  end

  context 'a material exists' do
    before(:each) do
      @material = find_or_factory(:material)
      @material.company = @user.company
      @material.save
    end

    it "should show material" do
      get :show, :id => @material.id
      assert_response :success
    end

    it "should get edit" do
      get :edit, :id => @material.id
      assert_response :success
    end

    it "should update material" do
      put :update, :id => @material.id, :material => { :name => 'updated_name' }
      assert_redirected_to material_path(assigns(:material))
    end


    describe "PUT :update with invalid attributes" do
      before(:each) do
        Factory.create(:material, :name => "repeat_name")
        put :update, :id => @material.id, :material => { :name => "repeat_name" }
      end

      it { should render_template :edit }
    end

    it "should destroy material" do
      old_count = Material.count
      delete :destroy, :id => @material.id
      assert_equal old_count-1, Material.count

      assert_redirected_to materials_path
    end
  end
  
  describe "GET :get_hazards with a material that exists" do
    before(:each) do
      @material_id = Material.last.id
      get :get_hazards, :id => @material_id
    end

    it { should render_template :get_hazards }
    it { should assign_to(:material).with(Material.find(@material_id)) }
  end

  describe "GET :get_hazards with a material that does not exist" do
    before(:each) do
      material_id = Material.last.id + 1
      assert_nil Material.find_by_id(material_id)
      get :get_hazards, :id => material_id
    end

    it { should render_template :get_hazards }
    it "should return a new material object" do
      assert assigns(:material).new_record?
    end
  end

  describe "PUT :put_hazards with a valid material id" do
    before(:each) do
      @material_id = Material.last.id
      put :put_hazards, :id => @material_id
    end

    it { should redirect_to edit_material_path(@material_id) }
  end

  describe "PUT :put_hazards with invalid material id" do
    before(:each) do
      material_id = Material.last.id + 1
      put :put_hazards, :id => material_id
    end

    it { should redirect_to new_material_path }
  end
end

