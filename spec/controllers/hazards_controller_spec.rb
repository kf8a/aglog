require 'spec_helper'

describe HazardsController do
  render_views

  before(:each) do
    sign_in_as_normal_user
    @hazard = Factory.create(:hazard)
  end

  describe "get :index" do
    before(:each) do
      get :index
    end

    it { should respond_with :success }
    it { should assign_to :hazards }
  end

  describe "get :index when signed_out" do
    before(:each) do
      sign_out
      get :index
    end

    it { should render_template 'unauthorized_index' }
  end

  describe "get :new" do
    before(:each) do
      get :new
    end

    it { should respond_with :success }
  end

  describe "POST :create" do
    before(:each) do
      @old_count = Hazard.count
      post :create, :hazard => { }
    end

    it { should redirect_to hazard_path(assigns(:hazard)) }
    it "should create hazard" do
      Hazard.count.should be_eql(@old_count + 1)
    end
  end

  describe "GET :show" do
    before(:each) do
      get :show, :id => @hazard.id
    end

    it { should respond_with :success }
  end

  describe "GET :edit" do
    before(:each) do
      get :edit, :id => @hazard.id
    end

    it { should respond_with :success }
  end

  describe "PUT :update" do
    before(:each) do
      put :update, :id => @hazard.id, :hazard => { }
    end

    it { should redirect_to hazard_path(@hazard)}
  end

  describe "DELETE :destroy" do
    before(:each) do
      delete :destroy, :id => @hazard.id
    end

    it "should destroy the hazard" do
      Hazard.exists?(@hazard.id).should be_false
    end
    it {should redirect_to hazards_path }
  end
end
