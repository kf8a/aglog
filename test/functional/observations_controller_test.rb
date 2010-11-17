require 'test_helper'
require 'observations_controller'

class ObservationsControllerTest < ActionController::TestCase
  #fixtures :observations, :people, :areas

  def setup
    @controller = ObservationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:observations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_observation
    old_count = Observation.count
    post :create, "observation"=>
      {"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"25", 
        "areas_as_text"=>"t1r1", "comment"=>"Test at 14:45",
        "observation_type_ids"=>["3"]}, "commit"=>"Create", 
        "action"=>"create", 
        "activities"=>{
          "0"=>{"setups"=>{
            "0"=>{"equipment_id"=>"2", "material_transactions"=>{
              "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}}, 
              "hours"=>"1", "person_id"=>"2"}}
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
        "comment"=>"Test at 14:45", "observation_type_ids"=>["3"]}, 
        "commit"=>"Create", "action"=>"create", 
        "activities"=>{
          "0"=>{"setups"=>{
            "0"=>{"equipment_id"=>"2", "material_transactions"=>{
              "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}}, 
        "hours"=>"1", "person_id"=>"2"}}
    assert_redirected_to observation_path(assigns(:observation))
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
  	assert_equal "text/javascript; charset=utf-8",
        @response.headers["type"]
    
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
