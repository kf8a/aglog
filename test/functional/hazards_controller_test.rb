require File.dirname(__FILE__) + '/../test_helper'
require 'hazards_controller'

# Re-raise errors caught by the controller.
class HazardsController; def rescue_action(e) raise e end; end

class HazardsControllerTest < Test::Unit::TestCase
  fixtures :hazards

  def setup
    @controller = HazardsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:hazards)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_hazard
    assert_difference('Hazard.count') do
      post :create, :hazard => { }
    end

    assert_redirected_to hazard_path(assigns(:hazard))
  end

  def test_should_show_hazard
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_hazard
    put :update, :id => 1, :hazard => { }
    assert_redirected_to hazard_path(assigns(:hazard))
  end

  def test_should_destroy_hazard
    assert_difference('Hazard.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to hazards_path
  end
end
