require 'test_helper'

class HazardsControllerTest < ActionController::TestCase

  def setup
    sign_in_as_normal_user
    @hazard = Factory.create(:hazard)
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
    get :show, :id => @hazard.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @hazard.id
    assert_response :success
  end

  def test_should_update_hazard
    put :update, :id => @hazard.id, :hazard => { }
    assert_redirected_to hazard_path(assigns(:hazard))
  end

  def test_should_destroy_hazard
    assert_difference('Hazard.count', -1) do
      delete :destroy, :id => @hazard.id
    end

    assert_redirected_to hazards_path
  end
end
