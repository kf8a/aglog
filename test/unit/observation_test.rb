require 'test_helper'

class ObservationTest < ActiveSupport::TestCase

  def test_should_not_create_observation
    old_count =  Observation.count
    num_activities = Activity.count
    
    # no observation without created_on date
    o = Observation.new({:created_on => 'nodate'})  
    assert !o.save
    assert_equal old_count, Observation.count
    assert_equal num_activities, Activity.count
    
    # observation without valid activity
    o = Observation.new({:created_on => Date.today})
    a = Activity.new()
    o.activities << a
    
    assert !o.save
    assert_equal old_count, Observation.count
    assert_equal num_activities, Activity.count
        
  end
  
  def test_simple_observation
    o = create_simple_observation
    assert o.save 
    assert_equal  1, o.activities.size
    activity = o.activities[0]
    assert_equal 1, activity.setups.size
    setup =  activity.setups[0]
    assert_equal  2, setup.material_transactions.size
  end
  
  def test_delete_material
    o = create_simple_observation
    activity = o.activities[0]
    setup =  activity.setups[0]
    material_transaction = setup.material_transactions[0]
    assert_equal 2, setup.material_transactions.size
    
    setup.material_transactions.delete(material_transaction)
    assert_equal 1, setup.material_transactions.size
  end
  
  def test_delete_setup
    o = create_simple_observation
    activity = o.activities[0]
    setup =  activity.setups[0]    
    assert_equal 1, activity.setups.size
    
    activity.setups.delete(setup)
    assert_equal 0, activity.setups.size    
  end
  
  def test_delete_activity
    o = create_simple_observation
    activity = o.activities[0]    
    assert_equal 1, o.activities.size
    
    o.activities.delete(activity)
    assert_equal 0, o.activities.size
  end
  
  def test_add_activity_to_observation
    o = create_simple_observation
    assert o.save
    number_of_activities = Activity.count
    params = {
      "activities"=>{
        "0"=>{"setups"=>{
          "0"=>{"equipment_id"=>"2", "material_transactions"=>{
            "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"},
            "1"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}}, 
            "hours"=>"1", "person_id"=>"2"},
        "1"=>{"setups"=>{
          "0"=>{"equipment_id"=>"2", "material_transactions"=>{
            "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"},
            "1"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}}, 
          "hours"=>"1", "person_id"=>"2"}
      }
    }
    o.set_activities(params['activities'])
    assert_equal 2, o.activities.size
    assert o.save
    assert_equal number_of_activities+1, Activity.count
  end
     
  def test_add_setup_to_observation
    o = create_simple_observation
    assert o.save
    number_of_setups = Setup.count
    params = {
      "activities"=>{
        "0"=>{"setups"=>{
          "0"=>{"equipment_id"=>"2", "material_transactions"=>{
            "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"},
            "1"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}},
          "1"=>{"equipment_id"=>"2", "material_transactions"=>{
            "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"},
            "1"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}
            }, "hours"=>"1", "person_id"=>"2"}
      }
    }
    o.set_activities(params['activities'])
    assert_equal 2, o.activities[0].setups.size
    assert o.save
    assert_equal number_of_setups+1, Setup.count   
  end

  def test_get_review_status
    o = create_simple_observation
    assert_equal false, o.in_review
  end

  def test_set_review_status_to_review
    o = create_simple_observation
    assert o.save
    assert_equal false, o.in_review
    o.in_review = "1"
    assert_equal true, o.in_review
  end
  
  def test_set_review_status_to_published
    o = create_simple_observation
    assert o.save
    o.in_review = "0"
    assert_equal o.state, 'published'
  end
  
  def test_areas_as_text_with_error_areas
    o = create_simple_observation
    assert o.save
    original_areas = o.areas
    fake_areas = "NoArea"
    o.areas_as_text = fake_areas
    o.reload
    assert_equal original_areas, o.areas
    assert_equal "*NoArea*", o.areas_as_text
  end
  
  private
  
  def create_simple_observation
    params = {"observation"=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"14", 
      "areas_as_text"=>"", "comment"=>"", "person_id" => "1", 
      "observation_type_ids" => "1"}, 
      "commit"=>"Create", "activities"=>{
        "0"=>{"setups"=>{
          "0"=>{"equipment_id"=>"2", "material_transactions"=>{
            "0"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"},
            "1"=>{"material_id"=>"3", "rate"=>"4", "unit_id"=>"3"}}}}, 
            "hours"=>"1", "person_id"=>"2"}}
      }
    o = Observation.new(params['observation'])
    o.set_activities(params['activities'])
    return o
  end
end
