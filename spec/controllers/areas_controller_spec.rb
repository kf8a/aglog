require 'spec_helper'

describe AreasController do
  render_views

  describe 'Not signed in. ' do

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'index' }
    end

    describe 'POST :move_to' do
      before(:each) do
        post :move_to, {:id=> 1, :parent_id => 2}
      end

      it {should redirect_to new_user_session_path }
    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it { should redirect_to new_user_session_path }
    end

    describe 'POST :create' do
      before(:each) do
        Area.exists?(:name => 'T2R22').should be_false
        post :create, :area => { :name => 'T2R22' }
      end

      it { should redirect_to new_user_session_path }

      it "should not create an area" do
        Area.exists?(:name => 'T2R22').should be_false
      end
    end

    describe 'An area exists. ' do
      before(:each) do
        @area = FactoryGirl.create(:area, :name => 'standard_area', company_id: 1)
      end

      describe 'GET :show the area' do
        before(:each) do
          get :show, :id => @area.id
        end

        it { should render_template 'show' }
      end

      describe 'The area is a branch with leaves that have observations. ' do
        before(:each) do
          @area1 = FactoryGirl.create(:area, company_id: 1)
          @area1.observations << FactoryGirl.create(:observation)
          @area1.move_to_child_of(@area)
          assert @area.leaves.include?(@area1)
        end

        describe 'GET :show the area' do
          before(:each) do
            get :show, :id => @area.id
          end

        end
      end

      describe 'GET :edit the area' do
        before(:each) do
          get :edit, :id => @area.id
        end

        it { should redirect_to new_user_session_path }
      end

      describe 'PUT :update the area' do
        before(:each) do
          put :update, :id => @area.id, :area => { :name => 'new_area' }
        end

        it { should redirect_to new_user_session_path }
        it "should not change the area" do
          @area.reload
          @area.name.should_not match 'new_area'
        end
      end

      describe 'DELETE :destroy the area' do
        before(:each) do
          delete :destroy, :id => @area.id
        end

        it { should redirect_to new_user_session_path }
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

      it { should render_template 'index' }
    end

    describe 'GET :index with :q => "T" as json' do
      before(:each) do
        get :index, :q => "T", :format => :json
      end

    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it { should render_template 'new' }
    end

    describe 'POST :create' do
      before(:each) do
        Area.exists?(:name => 'T2R22').should be_false
        post :create, :area => { :name => 'T2R22' }
      end

      it { should redirect_to area_path(assigns(:area)) }
      it "should create an area" do
        Area.exists?(:name => 'T2R22').should be_true
      end
      it { should set_the_flash }
    end

    describe "POST :create with invalid attributes" do
      before(:each) do
        find_or_factory(:area, :name => 'repeat_name', :company_id => @user.company_id)
        post :create, :area => { :name => 'repeat_name' }
      end

      it { should render_template 'new' }
      it { should_not set_the_flash }
    end

    describe "An area exists. " do
      before(:each) do
        @area = find_or_factory(:area, {:name => 'existing_area',
                               :company_id=>@user.company_id})
      end

      describe "GET :show the area" do
        before(:each) do
          get :show, :id => @area.id
        end

        it { should render_template 'show' }
      end

      describe "GET :edit the area" do
        before(:each) do
          get :edit, :id => @area.id
        end

        it { should render_template 'edit' }
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
          find_or_factory(:area, {:name => 'repeat_name',
                          :company_id => @user.company.id})
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
