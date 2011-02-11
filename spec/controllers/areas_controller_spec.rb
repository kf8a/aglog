require 'spec_helper'

describe AreasController do
  
  describe 'Not signed in. ' do
    before(:each) do
      sign_out
    end

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'unauthorized_index' }
      it { should assign_to :areas }
    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it { should redirect_to new_person_session_path }
    end

    describe 'POST :create' do
      before(:each) do
        Area.exists?(:name => 'T2R22').should be_false
        post :create, :area => { :name => 'T2R22' }
      end

      it { should redirect_to new_person_session_path }
      
      it "should not create an area" do
        Area.exists?(:name => 'T2R22').should be_false
      end
    end

    describe 'An area exists. ' do
      before(:each) do
        @area = Factory.create(:area, :name => 'standard_area')
      end

      describe 'GET :show the area' do
        before(:each) do
          get :show, :id => @area.id
        end

        it { should render_template 'unauthorized_show' }
        it { should assign_to(:area).with(@area) }
        it { should assign_to(:observations) }
      end

      describe 'GET :edit the area' do
        before(:each) do
          get :edit, :id => @area.id
        end

        it { should redirect_to new_person_session_path }
      end

      describe 'PUT :update the area' do
        before(:each) do
          put :update, :id => @area.id, :area => { :name => 'new_area' }
        end

        it { should redirect_to new_person_session_path }
        it "should not change the area" do
          @area.reload
          @area.name.should_not match 'new_area'
        end
      end

      describe 'DELETE :destroy the area' do
        before(:each) do
          delete :destroy, :id => @area.id
        end

        it { should redirect_to new_person_session_path }
        it "should not destroy the area" do
          Area.exists?(@area.id).should be_true
        end
      end
    end
  end

  describe 'Signed in as normal user. ' do
    before(:each) do
      sign_in_as_normal_user
    end

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'authorized_index' }
      it { should assign_to :areas }
    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it { should render_template 'new' }
      it { should assign_to(:area).with_kind_of(Area) }
    end

    describe 'POST :create' do
      before(:each) do
        assert_nil Area.find_by_name('T2R22')
        post :create, :area => { :name => 'T2R22' }
      end

      it { should redirect_to area_path(assigns(:area)) }
      it "should create an area" do
        Area.exists?(:name => 'T2R22').should be_true
      end
      it { should set_the_flash }
    end

    describe "POST :create with xml format" do
      before(:each) do
        post :create, :area => { :name => 'XMLTEST' }, :format => 'xml'
      end

      it { should respond_with(201) }
      it { should respond_with_content_type(:xml) }
    end

    describe "POST :create with invalid attributes" do
      before(:each) do
        Factory.create(:area, :name => 'repeat_name')
        post :create, :area => { :name => 'repeat_name' }
      end

      it { should render_template 'new' }
      it { should_not set_the_flash }
    end

    describe "An area exists. " do
      before(:each) do
        @area = Factory.create(:area, :name => 'existing_area')
      end

      describe "GET :show the area" do
        before(:each) do
          get :show, :id => @area.id
        end

        it { should render_template 'authorized_show' }
        it { should assign_to(:area).with(@area) }
        it { should assign_to(:observations) }
      end

      describe "GET :edit the area" do
        before(:each) do
          get :edit, :id => @area.id
        end

        it { should render_template 'edit' }
        it { should assign_to(:area).with(@area) }
      end

      describe "PUT :update the area with valid attributes" do
        before(:each) do
          put :update, :id => @area.id, :area => { :name => 'new_area'}
        end

        it { should redirect_to area_path(@area) }
        it "should change the area" do
          @area.reload
          @area.name.should match 'new_area'
        end
      end

      describe "PUT :update with invalid attributes" do
        before(:each) do
          Factory.create(:area, :name => 'repeat_name')
          put :update, :id => @area.id, :area => { :name => 'repeat_name' }
        end

        it { should render_template 'edit' }
        it "should not change the area" do
          @area.reload
          @area.name.should_not match 'repeat_name'
        end
      end

      describe "DELETE :destroy the area" do
        before(:each) do
          delete :destroy, :id => @area.id
        end

        it { should redirect_to areas_path }
        it "should destroy the area" do
          Area.exists?(@area.id).should be_false
        end
      end
    end
  end
end
