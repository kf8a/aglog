require 'rails_helper'

describe AreasController, type: :controller do
  render_views

  let(:area) { FactoryBot.build_stubbed(:area, name: "custom area")}

  before :each do
    allow(area).to receive(:save).and_return(true)
    allow(Area).to receive(:persisted?).and_return(true)
    allow(Area).to receive(:find).with(area.id.to_s).and_return(area)
    allow(Area).to receive(:by_company).and_return(Area)
  end

  describe 'Not signed in. ' do

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'index' }
    end

    it 'should not allow POST :move' do
      post :move_to, {:id=> 1, :parent_id => 2}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow GET :new' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    describe 'POST :create' do
      before(:each) do
        post :create, :area => { :name => 'T2R22' }
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create the area' do
        expect(Area.exists?(:name => 'T2R22')).to eq false
      end
    end

    describe 'GET :show the area' do
      before(:each) do
        get :show, :id => area
      end

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it { should render_template 'show' }
    end

    it 'does not allow GET :edit' do
      get :edit, :id => area
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow PUT :update' do
      put :update, :id => area, :area => { :name => 'new_area' }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow destroy' do
        delete :destroy, :id => area
        expect(response).to redirect_to new_user_session_path
    end

    # describe 'The area is a branch with leaves that have observations. ' do
    #   before(:each) do
    #     @area1 = FactoryBot.create(:area, company_id: 1)
    #     @area1.observations << FactoryBot.create(:observation)
    #     @area1.move_to_child_of(@area)
    #     assert @area.leaves.include?(@area1)
    #   end

    #   describe 'GET :show the area' do
    #     before(:each) do
    #       get :show, :id => @area.id
    #     end

    #   end
    # end
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

    # describe 'GET :index with :q => "T" as json' do
    #   before(:each) do
    #     get :index, :q => "T", :format => :json
    #   end

    #   it {should render_template 'index' }

    # end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it 'renders the template new' do
        expect(response).to render_template 'new'
      end

      it 'assigns a new area to @area' do
        expect(assigns(:area)).to be_a_new(Area)
      end
    end

    describe 'POST :create' do
      before(:each) do
        post :create, :area => { :name => 'T2R22' }
      end

      it { should redirect_to area_path(assigns(:area)) }
      it "should create an area" do
        expect(Area.exists?(:name => 'T2R22')).to eq true
      end
      it { should set_flash }
    end

    describe "POST :create with invalid attributes" do
      before(:each) do
        allow_any_instance_of(Area).to receive(:valid?).and_return(false)
        post :create, :area => { :name => 'repeat_name' }
      end

      it { should render_template 'new' }
      it { should_not set_flash }
    end


    describe "GET :show the area" do
      before(:each) do
        get :show, :id => area
      end

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it { should render_template 'show' }
    end

    describe "GET :edit the area" do
      before(:each) do
        get :edit, :id => area
      end

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it { should render_template 'edit' }
    end

    describe "PUT :update the area with valid attributes" do
      before(:each) do
        put :update, :id => area, :area => { :name => 'new_area'}
      end

      it { should redirect_to area_url(assigns(:area)) }

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it "should change the area" do
        expect(area.name).to eq 'new_area'
      end
    end

    describe "PUT :update with invalid attributes" do
      before(:each) do
        allow(area).to receive(:update_attributes).and_return(false)
        put :update, :id => area, :area => { :name => 'repeat_name' }
      end

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it "should not change the area" do
        expect(area.name).to_not eq 'repeat_name'
      end

      it { should render_template 'edit' }
    end

    describe "DELETE :destroy the area" do
      before(:each) do
        allow(area).to receive(:destroy).and_return(true)
        delete :destroy, :id => area
      end

      it { should redirect_to areas_path }
      it "should destroy the area" do
        expect(Area.exists?(area.id)).to eq false
      end
    end
  end
end
