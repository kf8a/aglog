require 'spec_helper'

describe PeopleController do
  render_views
  
  before(:each) do
    sign_in_as_normal_user
    @person = find_or_factory(:person)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert assigns(:people)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create person" do
    old_count = Person.count
    post :create, :person => { :given_name => 'given'}
    assert_equal old_count+1, Person.count

    assert_redirected_to person_path(assigns(:person))
  end

  describe "POST :create with invalid attributes" do
    before(:each) do
      post :create, :person => { :given_name => nil, :sur_name => nil }
    end

    it { should render_template 'new' }
    it { should_not set_the_flash }
  end

  it "should show person" do
    get :show, :id => @person.id
    assert_response :success
  end

  it "should get edit" do
    get :edit, :id => @person.id
    assert_response :success
  end

  it "should update person" do
    put :update, :id => @person.id, :person => { :given_name => 'bob', :sur_name => 'hastings'}
    assert_redirected_to person_path(assigns(:person))
  end

  describe "PUT :update with invalid attributes" do
    before(:each) do
      put :update, :id => @person.id, :person => { :given_name => nil, :sur_name => nil }
    end

    it { should render_template 'edit' }
    it { should_not set_the_flash }
  end

  it "should destroy person" do
    old_count = Person.count
    delete :destroy, :id => @person.id
    assert_equal old_count-1, Person.count

    assert_redirected_to people_path
  end
end

