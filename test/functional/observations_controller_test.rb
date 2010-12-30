require 'test_helper'

class ObservationsControllerTest < ActionController::TestCase

  setup do
    sign_in_as_normal_user
    Equipment.find_by_id(2) or 2.times do |num|
      Factory.create(:equipment, :name => "Equipment#{num}")
    end
    Material.find_by_id(3) or 3.times do |num|
      Factory.create(:material, :name => "Material#{num}")
    end
    Unit.find_by_id(3) or 3.times do |num|
      Factory.create(:unit, :name => "Unit#{num}")
    end
    Person.find_by_id(2) or 2.times do |num|
      Factory.create(:person, :sur_name => "Sur#{num}")
    end
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:observations)
  end

  context "GET :index, in_review is true" do
    setup do
      @obs_in_review = Factory.create(:observation)
      @obs_in_review.in_review = '1'
      @obs_published = Factory.create(:observation)
      @obs_published.in_review = '0'
      assert @obs_in_review.in_review
      assert !@obs_published.in_review
      get :index, :in_review => true
    end

    should "only include observation in review" do
      assert assigns(:observations).include?(@obs_in_review)
      assert !assigns(:observations).include?(@obs_published)
    end
  end

  context "GET :index, with observation type selected" do
    setup do
      @observation_type = Factory.create(:observation_type)
      @correct_type_observation = Factory.create(:observation, :observation_types => [@observation_type])
      @wrong_type_observation = Factory.create(:observation)
      assert @correct_type_observation.observation_types.include?(@observation_type)
      assert !@wrong_type_observation.observation_types.include?(@observation_type)
      get :index, :obstype => @observation_type.id
    end

    should "only include observation of correct type" do
      assert assigns(:observations).include?(@correct_type_observation)
      assert !assigns(:observations).include?(@wrong_type_observation)
    end
  end

  context "GET :index in salus_xml format" do
    setup do
      get :index, :format => 'salus_xml'
    end

    should respond_with_content_type('text/xml')
  end

  context "GET :index in salus_csv format" do
    setup do
      get :index, :format => 'salus_csv'
    end

    should respond_with_content_type('text/text')
  end

  context "GET :new" do
    setup do
      get :new
    end

    should render_template 'new'
  end

  context "POST :create" do
    setup do
      @observation_count = Observation.count
      post :create, :observation => { :obs_date => Date.today,
                                      :observation_type_ids => ["3"] }
    end

    should "create an observation" do
      assert_equal @observation_count + 1, Observation.count
    end

    should "assign the current user as the observation's person" do
      assert_equal @user.id, assigns(:observation).person_id
    end
  end

  def test_should_not_create_observation_or_activity
     old_count = Observation.count
     num_activities =  Activity.count

     xhr(:post, :create, :commit => "Create Observation", :observation => {:created_on => 'nodate'})
     assert_equal old_count, Observation.count
     assert_equal num_activities, Activity.count
     assert_response :success

     xhr(:post, :create, :commit => "Create Observation", :observation => {:obs_date => 'nodate'})
     assert_equal old_count, Observation.count

     xhr(:post, :create, :commit => "Create Observation", :observation => {:obs_date => Date.today},
     :activity => {0 => {:user_id => 50}})
     assert_equal old_count, Observation.count
     assert_equal num_activities, Activity.count
     assert_response :success
   end

  context "An observation exists. " do
    setup do
      @observation = Factory.create(:observation)
    end

    context "GET :show the observation" do
      setup do
        get :show, :id => @observation.id
      end

      should render_template 'show'
    end

    context "GET :edit the observation" do
      setup do
        get :edit, :id => @observation.id
      end

      should render_template 'edit'
    end

    context "PUT :update the observation" do
      setup do
        @current_obs_date = @observation.obs_date
        xhr(:put, :update, :id => @observation.id, :commit => "Update Observation", :observation => { :obs_date => @current_obs_date - 1 })
      end

      should "update the observation" do
        @observation.reload
        assert_equal @current_obs_date - 1, @observation.obs_date
      end
    end

    context "PUT :update with invalid attributes" do
      setup do
        @current_obs_date = @observation.obs_date
        xhr(:put, :update, :id => @observation.id, :commit => "Update Observation", :observation => { :person_id => nil, :obs_date => @current_obs_date - 1 })
      end

      should "not update the observation" do
        @observation.reload
        assert_equal @current_obs_date, @observation.obs_date
      end
    end

    context "DELETE :destroy the observation" do
      setup do
        delete :destroy, :id => @observation.id
      end

      should redirect_to("The observations path") {observations_path}
    end
  end

  private###########

  def default_params(commit_text)

        {"observation"=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"27",
  		  "areas_as_text"=>"", "comment"=>""},
  		  "commit"=>commit_text, "activity_index"=>"0",
  		  "setup_index"=>"0", :id => '',
  		  "activities"=>{
  		    "0"=>{"setups"=>{
  		      "0"=>{"equipment_id"=>"2", "material_transactions"=>{
  		        "0"=>{"material_id"=>"3", "rate"=>"5", "unit_id"=>"3"}}}},
  		        "hours"=>"1", "person_id"=>"2"}},
  		        "controller"=>"observations", "material_index"=>"0"}
  end
  
end
