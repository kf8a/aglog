require File.dirname(__FILE__) + '/../test_helper'
require 'reports_controller'

# Re-raise errors caught by the controller.
class ReportsController; def rescue_action(e) raise e end; end

class ReportsControllerTest < Test::Unit::TestCase
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
