require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  def setup
    sign_in_as_normal_user
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

  context "POST :create with invalid attributes" do
    setup do
      post :create, :person => { :given_name => nil, :sur_name => nil }
    end

    should render_template 'new'
    should_not set_the_flash
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

  context "PUT :update with invalid attributes" do
    setup do
      put :update, :id => @person.id, :person => { :given_name => nil, :sur_name => nil }
    end

    should render_template 'edit'
    should_not set_the_flash
  end
  
  def test_should_destroy_person
    old_count = Person.count
    delete :destroy, :id => @person.id
    assert_equal old_count-1, Person.count
    
    assert_redirected_to people_path
  end
end
