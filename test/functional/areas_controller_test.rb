require 'test_helper'

class AreasControllerTest < ActionController::TestCase

  def setup
    sign_in_as_normal_user
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

  context "POST :create with xml format" do
    setup do
      post :create, :area => { :name => 'XMLTEST' }, :format => 'xml'
    end

    should respond_with(201)
    should respond_with_content_type(:xml)
  end

  context "POST :create with invalid attributes" do
    setup do
      Factory.create(:area, :name => 'repeat_name')
      post :create, :area => { :name => 'repeat_name' }
    end

    should render_template 'new'
    should_not set_the_flash
  end

  context "An area exists. " do
    setup do
      @area = Factory.create(:area)
    end
    
    context "GET :show the area" do
      setup do
        get :show, :id => @area.id
      end

      should render_template 'show'
    end

    context "GET :edit the area" do
      setup do
        get :edit, :id => @area.id
      end

      should render_template 'edit'
    end

    context "PUT :update the area with valid attributes" do
      setup do
        put :update, :id => @area.id, :area => { :name => 'new_area'}
      end

      should redirect_to("the area show page") {area_path(@area)}
    end

    context "PUT :update with invalid attributes" do
      setup do
        Factory.create(:area, :name => 'repeat_name')
        put :update, :id => @area.id, :area => { :name => 'repeat_name' }
      end

      should render_template 'edit'
    end

    context "DELETE :destroy the area" do
      setup do
        delete :destroy, :id => @area.id
      end

      should redirect_to("the areas index") {areas_path}
    end
  end
end
