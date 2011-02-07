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
  
  it "GET :index, ordered by material" do
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

