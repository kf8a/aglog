require 'spec_helper'

describe ReportsController do
  render_views

  before(:each) do
    sign_in_as_normal_user
  end

  it "GET :index, ordered by plot" do
    get :index, :order=>'plot'
    assert_response :success
  end

  it "GET :index, ordered by plot ascending" do
    session[:current_order] = 'areas.name desc, obs_date desc, materials.name'
    get :index, :order => 'plot'
    assert_response :success
  end

  it "GET :index, ordered by material" do
    get :index, :order => 'material'
    assert_response :success
  end

  it "GET :index, ordered by material ascending" do
    session[:current_order] = 'materials.name desc, obs_date desc, areas.name'
    get :index, :order => 'material'
    assert_response :success
  end

  it "GET :index, ordered by date" do
    get :index, :order => 'date'
    assert_response :success
  end

  it "GET :index, ordered by something_else" do
    get :index, :order => 'something_else'
    assert_response :success
  end
end
