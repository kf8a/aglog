require 'test_helper'

class AreasControllerTest < ActionController::TestCase

  context 'Not signed in. ' do
    setup do
      sign_out
    end

    context 'GET :index' do
      setup do
        get :index
      end

      should render_template 'unauthorized_index'
      should assign_to :areas
    end


  end

  context 'Signed in as normal user. ' do
    setup do
      sign_in_as_normal_user
    end

    context 'GET :index' do
      setup do
        get :index
      end

      should render_template 'authorized_index'
      should assign_to :areas
    end

    context 'GET :new' do
      setup do
        get :new
      end

      should render_template 'new'
      should assign_to(:area).with_kind_of(Area)
    end

    context 'POST :create' do
      setup do
        assert_nil Area.find_by_name('T2R22')
        post :create, :area => { :name => 'T2R22' }
      end

      should ('redirect to the created area'){redirect_to area_path(assigns(:area))}
      should 'create an area' do
        assert Area.find_by_name('T2R22')
      end
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

        should render_template 'authorized_show'
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

  
end
