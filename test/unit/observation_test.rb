require 'test_helper'

class ObservationTest < ActiveSupport::TestCase

  setup do
  end
  
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
  
  def test_set_review_status_to_published_from_in_review
    o = create_simple_observation
    assert o.save
    o.in_review = "1"
    assert_equal o.state, 'in_review'
    o.in_review = "0"
    assert_equal o.state, 'published'
  end

  def test_set_review_status_fails_elegantly_for_new_records
    o = Observation.new
    o.in_review = "0"
    assert o.state != 'published'
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
    assert !o.save
    assert_equal ["invalid areas"],  o.errors[:base]
  end

  def test_equipment_names
    o = create_simple_observation
    another_equipment = Factory.create(:equipment, :name => "Another Equipment")
    evil_equipment = Factory.create(:equipment, :name => "Evil Equipment")
    another_setup = o.setups.new(:equipment_id => another_equipment.id)
    another_setup.save
    assert_equal "Equipment2, Another Equipment", o.equipment_names
  end
  
  def test_materials_with_rates
    o = create_simple_observation
    activity = Factory.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || Factory.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || Factory.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || Factory.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal "Material3: 4.0 Unit3s per acre, Material4: 5.0 Unit4s per acre", o.materials_with_rates
  end

  def test_observation_type
    o = create_simple_observation
    assert_equal "Soil Preparation", o.observation_type
  end

  def test_observation_type_names
    o = create_simple_observation
    another_type = ObservationType.new(:name => "Another Type", :observations => [o])
    assert another_type.save
    o.observation_types << another_type
    assert o.save
    o.reload
    assert_equal "Soil Preparation, Another Type", o.observation_type_names
  end

  def test_areas_as_text
    o = create_simple_observation
    text_areas =  "MAIN"
    o.areas_as_text = text_areas
    assert_equal text_areas, o.areas_as_text
  end

  def test_material_names
    o = create_simple_observation
    activity = Factory.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || Factory.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || Factory.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || Factory.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal ["Material3", "Material4"], o.material_names
  end

  #TODO This test, material_names, and materials_with_rates should be refactored
  def test_n_contents
    o = create_simple_observation
    activity = Factory.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || Factory.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || Factory.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || Factory.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    material = Material.find_by_name("Material3")
    material.n_content = 40
    material.save
    material = Material.find_by_name("Material4")
    material.n_content = 30
    material.save
    assert_equal [40.0, 30.0], o.n_contents
  end

  def test_rates
    o = create_simple_observation
    activity = Factory.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || Factory.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || Factory.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || Factory.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal [4.0, 5.0], o.rates
  end

  def test_unit_names
    o = create_simple_observation
    activity = Factory.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || Factory.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || Factory.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || Factory.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal ['Unit3', 'Unit4'], o.unit_names
  end
  
  private
  
  def create_simple_observation
    person1 = Person.find_by_sur_name("Sur1") || Factory.create(:person, :sur_name => "Sur1")
    observation = Observation.new(:obs_date => "June 14, 2007", :person_id => person1.id, :observation_type_ids => [1])
    assert observation.save
    person2 = Person.find_by_sur_name("Sur2") || Factory.create(:person, :sur_name => "Sur2")
    activity = observation.activities.new(:hours => 1, :person_id => person2.id)
    assert activity.save
    equipment = Equipment.find_by_name("Equipment2") || Factory.create(:equipment, :name => "Equipment2")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material3") || Factory.create(:material, :name => "Material3")
    unit = Unit.find_by_name("Unit3") || Factory.create(:unit, :name => "Unit3")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 4, :unit_id => unit.id)
    assert trans_0.save
    trans_1 = setup.material_transactions.new(:material_id => material.id, :rate => 4, :unit_id => unit.id)
    assert trans_1.save
    observation.reload

    return observation
  end
end
