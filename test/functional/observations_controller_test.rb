require 'test_helper'

class ObservationsControllerTest < ActionController::TestCase

  def setup
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

    should respond_with :success
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

    should respond_with :success
    should "only include observation of correct type" do
      assert assigns(:observations).include?(@correct_type_observation)
      assert !assigns(:observations).include?(@wrong_type_observation)
    end
  end

  context "GET :index in salus_xml format" do
    setup do
      get :index, :format => 'salus_xml'
    end

    should respond_with :success
    should respond_with_content_type('text/xml')
  end

  context "GET :index in salus_csv format" do
    setup do
      get :index, :format => 'salus_csv'
    end

    should respond_with :success
    should respond_with_content_type('text/text')
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_observation
    old_count = Observation.count
    post :create, "observation"=>
      {"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"25", 
        "observation_type_ids"=>["3"]}
    assert_equal old_count+1, Observation.count
    
    assert_redirected_to observation_path(assigns(:observation))
  end
  
  
  def test_should_not_create_observation_or_activity
     old_count = Observation.count
     num_activities =  Activity.count
   
     post :create, :observation => {:created_on => 'nodate'}
     assert_equal old_count, Observation.count
     assert_equal num_activities, Activity.count
     assert_response :success
     
     post :create, :observation => {:obs_date => 'nodate'}
     assert_equal old_count, Observation.count
   
     post :create, :observation => {:obs_date => Date.today},
     :activity => {0 => {:user_id => 50}}
     assert_equal old_count, Observation.count
     assert_equal num_activities, Activity.count
     assert_response :success
   end

  context "POST :create in xml format" do
    setup do
      post :create,
           :format => 'xml',
           :observation => {"obs_date(1i)"=>"2007",
                            "obs_date(2i)"=>"6",
                            "obs_date(3i)"=>"25",
                            "observation_type_ids"=>["3"]}
    end

    should respond_with(201)
    should respond_with_content_type(:xml)
  end
 	
  def test_should_show_observation
    get :show, :id => 331
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 331
    assert_response :success
  end
  
  def test_should_update_observation
    put :update, :id => 331, 
      :observation=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", 
        "obs_date(3i)"=>"25", "areas_as_text"=>"t1r1", 
        "comment"=>"Test at 14:45", "observation_type_ids"=>["3"]}
    assert_redirected_to observation_path(assigns(:observation))
  end

  context "PUT :update with invalid attributes" do
    setup do
      put :update, :id => 331, :observation => {:person_id => nil}
    end

    should render_template 'edit'
    should_not set_the_flash
  end
  
  def test_should_destroy_observation
    old_count = Observation.count
    delete :destroy, :id => 331
    assert_equal old_count-1, Observation.count
    
    assert_redirected_to observations_path
  end
  
  def test_add_activity_to_observation 
    xhr :post, :add_activity, default_params
#		assert_select_rjs :insert, :bottom,  "activites"
 		assert_select_rjs # asserts that one or more elements are updated or inserted by RJS statements 
    assert_response :success
  end
  
  def test_add_setup_to_activity
    params = default_params
  	xhr(:post, :add_setup, params)
  	assert_response :success
  end
  
  def test_add_material_to_setup
  	xhr :post, :add_material, default_params

 		assert_select_rjs :replace, "activities"
  	assert_response :success
#  	assert_equal "text/javascript; charset=utf-8",
#        @response.headers["type"]
    
  end 
  
  def test_add_material_to_setup_while_editing
    get :edit, :id => 331
    assert_response :success
    
  end
  		
  def test_delete_material_from_setup
  	xhr(:delete, :delete_material,
  		"observation"=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"27", 
  		  "areas_as_text"=>"", "comment"=>""}, 
  		  "commit"=>"Create", "activity_index"=>"0", 
  		  "action"=>"delete_material", "setup_index"=>"0", :id => '',
  		  "activities"=>{
  		    "0"=>{"setups"=>{
  		      "0"=>{"equipment_id"=>"2", "material_transactions"=>{
  		        "0"=>{"material_id"=>"3", "rate"=>"5", "unit_id"=>"3"}}}}, 
  		        "hours"=>"1", "person_id"=>"2"}}, 
  		        "controller"=>"observations", "material_index"=>"0")
 		assert_select_rjs
  	assert_response :success
  end
  
  def test_delete_setup_from_activity
  	xhr(:delete, :delete_setup,
  		"observation"=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"27", 
  		  "areas_as_text"=>"", "comment"=>""}, 
  		  "commit"=>"Create", "activity_index"=>"0", 
  		  "action"=>"delete_setup", "setup_index"=>"0", :id => '',
  		  "activities"=>{
  		    "0"=>{"setups"=>{
  		      "0"=>{"equipment_id"=>"2"}}, "hours"=>"1", "person_id"=>"2"}}, 
  		      "controller"=>"observations")
 		assert_select_rjs
  	assert_response :success
  end
  
  def test_delete_activity_from_observation
  	xhr(:delete, :delete_activity, 
  		"observation"=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"27", 
  		  "areas_as_text"=>"", "comment"=>""}, 
  		  "commit"=>"Create", "activity_index"=>"0", :id  => '',
  		  "action"=>"delete_activity", 
  		  "activities"=>{
  		    "0"=>{"hours"=>"1", "person_id"=>"2"}}, 
  		    "controller"=>"observations")
 		assert_select_rjs
  	assert_response :success
  end
  
  def test_add_setup_to_activity_when_editing_observation
    number_of_setups = Setup.count
    put :update, :id => 331, 
      :observation=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"25", 
        "areas_as_text"=>"t1r1", "comment"=>"Test at 14:45", 
        "observation_type_ids"=>["3"]},
        :commit=>"Update", :action=>"create",
        :activities=>{
          "0"=>{"setups"=>{
            "0"=>{"equipment_id"=>"2", 
              "material_transactions"=>{
                "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}
              }
            },
            "1"=>{"equipment_id"=>"2", 
              "material_transactions"=>{
                "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}
              }
            }      
          }, "hours"=>"1", "person_id"=>"2"}
        }
    
     assert_redirected_to observation_path(assigns(:observation))
     assert_equal number_of_setups+1, Setup.count
  end
  
  def test_add_activity_when_editing_observation
    number_of_activities = Activity.count
    put :update, :id => 331, 
      :observation=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"25", 
        "areas_as_text"=>"t1r1", "comment"=>"Test at 14:45", "observation_type_ids"=>["3"]},
        "commit"=>"Update", "action"=>"create", :id => '331',
        "activities"=>{
          "0"=>{"setups"=>{
            "0"=>{"equipment_id"=>"2", 
              "material_transactions"=>{
                "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}
              }
            }
          }, "hours"=>"1", "person_id"=>"2"},
          "1"=>{"setups"=>{
             "0"=>{"equipment_id"=>"2", 
               "material_transactions"=>{
                 "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}
               }
             }
           }, "hours"=>"1", "person_id"=>"2"}
          
        }   
    assert_redirected_to observation_path(assigns(:observation))
    assert_equal number_of_activities+1, Activity.count
  end
  private
  def default_params
    {"observation" => 
  	{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"25", 
       "areas_as_text"=>"t1r1", "comment"=>"Test at 14:45",
       "observation_type_ids"=>["3"]}, "commit"=>"Create", :id => '',
       "action"=>"create", 
       "activities"=>{
         "0"=>{"setups"=>{
           "0"=>{"equipment_id"=>"2", "material_transactions"=>{
             "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}}, 
             "hours"=>"1", "person_id"=>"2"}}
    }
  end
  
end
