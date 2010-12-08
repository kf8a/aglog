require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  def setup
    sign_in_as_normal_user
  end

  def test_plot_sort
    get :index, :order=>'plot'
    assert_response :success
  end
  
  def test_material_sort
    get :index, :order => 'material'
    assert_response :success
  end
  
  def test_date_sort
    get :index, :order => 'date'
    assert_response :success
  end

  def test_other_sort
    get :index, :order => 'something_else'
    assert_response :success
  end
end
