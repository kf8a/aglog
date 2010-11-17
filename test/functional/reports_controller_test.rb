require 'test_helper'
require 'reports_controller'

class ReportsControllerTest < ActionController::TestCase
  def setup
    @controller = ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
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
end
