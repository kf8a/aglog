require 'spec_helper'

describe HazardsController do
  render_views
  
  before(:each) do
    sign_in_as_normal_user
    @hazard = Factory.create(:hazard)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert assigns(:hazards)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create hazard" do
    hazards = Hazard.count
    post :create, :hazard => { }
    assert_redirected_to hazard_path(assigns(:hazard))
    assert_equal hazards + 1, Hazard.count
  end

  it "should show hazard" do
    get :show, :id => @hazard.id
    assert_response :success
  end

  it "should get edit" do
    get :edit, :id => @hazard.id
    assert_response :success
  end

  it "should update hazard" do
    put :update, :id => @hazard.id, :hazard => { }
    assert_redirected_to hazard_path(assigns(:hazard))
  end

  it "should destroy hazard" do
    hazards = Hazard.count
    delete :destroy, :id => @hazard.id
    assert_redirected_to hazards_path
    assert_equal hazards - 1, Hazard.count
  end
end
