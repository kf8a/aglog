require 'test_helper'
require 'people_controller'

class PeopleControllerTest < ActionController::TestCase

  def setup
    @person = Factory.create(:person)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:people)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_person
    old_count = Person.count
    post :create, :person => { :given_name => 'given'}
    assert_equal old_count+1, Person.count
    
    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_show_person
    get :show, :id => @person.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @person.id
    assert_response :success
  end
  
  def test_should_update_person
    put :update, :id => @person.id, :person => { :given_name => 'bob', :sur_name => 'hastings'}
    assert_redirected_to person_path(assigns(:person))
  end
  
  def test_should_destroy_person
    old_count = Person.count
    delete :destroy, :id => @person.id
    assert_equal old_count-1, Person.count
    
    assert_redirected_to people_path
  end
end
