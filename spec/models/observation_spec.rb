require 'spec_helper'

describe Observation do
  it {should validate_presence_of :obs_date}
  it {should validate_presence_of :person}
  it {should validate_presence_of :observation_types}

  it 'should work normally with a simple observation' do
    o = create_simple_observation
    assert_equal  1, o.activities.size
    activity = o.activities[0]
    assert_equal 1, activity.setups.size
    setup =  activity.setups[0]
    assert_equal  2, setup.material_transactions.size
  end

  it 'should delete material' do
    o = create_simple_observation
    activity = o.activities[0]
    setup =  activity.setups[0]
    material_transaction = setup.material_transactions[0]
    assert_equal 2, setup.material_transactions.size

    setup.material_transactions.delete(material_transaction)
    assert_equal 1, setup.material_transactions.size
  end

  it 'should delete setup' do
    o = create_simple_observation
    activity = o.activities[0]
    setup =  activity.setups[0]
    assert_equal 1, activity.setups.size

    activity.setups.delete(setup)
    assert_equal 0, activity.setups.size
  end

  it 'should delete activity' do
    o = create_simple_observation
    activity = o.activities[0]
    assert_equal 1, o.activities.size

    o.activities.delete(activity)
    assert_equal 0, o.activities.size
  end

  it 'should not be valid if it has error areas' do
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

  it 'should have the right equipment_names' do
    o = create_simple_observation
    another_equipment = FactoryGirl.create(:equipment, :name => "Another Equipment")
    evil_equipment = FactoryGirl.create(:equipment, :name => "Evil Equipment")
    another_setup = o.setups.new(:equipment_id => another_equipment.id)
    another_setup.save
    assert_equal "Equipment2, Another Equipment", o.equipment_names
  end

  it 'should get the right materials_with_rates' do
    o = create_simple_observation
    activity = FactoryGirl.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || FactoryGirl.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || FactoryGirl.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || FactoryGirl.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal "Material3: 4.0 Unit3s per acre, Material4: 5.0 Unit4s per acre", o.materials_with_rates
  end

  it "should return the right observation_type" do
    o = create_simple_observation
    assert_equal "Soil Preparation", o.observation_type
  end

  #TODO: you should only be allowed to put an observation_type in once
  it "should give all of the right observation_type_names" do
    o = create_simple_observation
    another_type = ObservationType.new(:name => "Another Type") #, :observations => [o])
    assert another_type.save
    o.observation_types << another_type
    assert o.save
    o.reload
    assert_equal "Soil Preparation, Another Type", o.observation_type_names
  end

  it 'should accept token ids in areas_as_text' do
    o = create_simple_observation
    text_areas = '3,415'
    o.areas_as_text = text_areas
    o.save
    a_leaf = Area.find(3).expand.first
    b_leaf = Area.find(415).expand.first
    assert o.areas.include?(a_leaf)
    assert o.areas.include?(b_leaf)
  end

  it "should give the right material_names" do
    o = create_simple_observation
    activity = FactoryGirl.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || FactoryGirl.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || FactoryGirl.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || FactoryGirl.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal ["Material3", "Material4"], o.material_names
  end

  #TODO This test, material_names, and materials_with_rates should be refactored
  it "should give the right n_contents" do
    o = create_simple_observation
    activity = FactoryGirl.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || FactoryGirl.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || FactoryGirl.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || FactoryGirl.create(:unit, :name => "Unit4")
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

  it "should give the right rates" do
    o = create_simple_observation
    activity = FactoryGirl.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || FactoryGirl.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || FactoryGirl.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || FactoryGirl.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal [4.0, 5.0], o.rates
  end

  it "should give the right unit_names" do
    o = create_simple_observation
    activity = FactoryGirl.create(:activity, :observation_id => o.id)
    equipment = Equipment.find_by_name("Another Equipment") || FactoryGirl.create(:equipment, :name => "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || FactoryGirl.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || FactoryGirl.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal ['Unit3', 'Unit4'], o.unit_names
  end

  it "should allow observation date to be set easily" do
    o = create_simple_observation
    old_date = o.obs_date
    o.observation_date = "yesterday"
    assert_equal Date.today - 1.day, o.obs_date.to_date
  end

  private

  def create_simple_observation
    type = ObservationType.find_by_name('Soil Preparation')
    assert type
    person1 = Person.find_by_sur_name("Sur1") || FactoryGirl.create(:person, :sur_name => "Sur1")
    company = find_or_factory(:company)
    observation = Observation.new(:observation_date => "June 14, 2007", :company_id => company.id)
    observation.person = person1 
    observation.observation_types <<  type
    observation.should be_valid
    assert observation.save
    person2 = Person.find_by_sur_name("Sur2") || FactoryGirl.create(:person, :sur_name => "Sur2")
    activity = observation.activities.new(:hours => 1, :person_id => person2.id)
    assert activity.save
    equipment = Equipment.find_by_name("Equipment2") || FactoryGirl.create(:equipment, :name => "Equipment2")
    setup = activity.setups.new
    setup.equipment = equipment
    assert setup.save
    material = Material.find_by_name("Material3") || FactoryGirl.create(:material, :name => "Material3")
    unit = Unit.find_by_name("Unit3") || FactoryGirl.create(:unit, :name => "Unit3")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 4, :unit_id => unit.id)
    assert trans_0.save
    trans_1 = setup.material_transactions.new(:material_id => material.id, :rate => 4, :unit_id => unit.id)
    assert trans_1.save
    observation.reload

    return observation
  end
end
