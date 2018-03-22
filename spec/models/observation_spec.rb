require 'rails_helper'

describe Observation do
  it {is_expected.to validate_presence_of :obs_date}
  it {is_expected.to validate_presence_of :person}
  it {is_expected.to validate_presence_of :observation_types}


  it 'works normally with a simple observation' do
    o = create_simple_observation
    expect(o.activities.size).to eq 1
    activity = o.activities[0]
    expect(activity.setups.size).to eq 1
    setup =  activity.setups[0]
    expect(setup.material_transactions.size).to eq 2
    o.delete
  end

  it 'deletes material' do
    o = create_simple_observation
    activity = o.activities[0]
    setup =  activity.setups[0]
    material_transaction = setup.material_transactions[0]
    expect(setup.material_transactions.size).to eq 2

    setup.material_transactions.delete(material_transaction)
    expect(setup.material_transactions.size).to eq 1
    o.delete
  end

  it 'deletes setup' do
    o = create_simple_observation
    activity = o.activities[0]
    setup =  activity.setups[0]
    expect(activity.setups.size).to eq 1

    activity.setups.delete(setup)
    expect(activity.setups.size).to eq 0
    o.delete
  end

  it 'deletes activity' do
    o = create_simple_observation
    activity = o.activities[0]
    expect(o.activities.size).to eq 1

    o.activities.delete(activity)
    expect(o.activities.size).to eq 0
    o.delete
  end

  it 'is not valid if it has error areas' do
    o = create_simple_observation
    assert o.save
    original_areas = o.areas
    fake_areas = "NoArea"
    o.areas_as_text = fake_areas
    o.reload
    expect(o.areas).to eq original_areas
    expect(o.areas_as_text).to eq '*NoArea*'
    assert !o.save
    assert_equal ["invalid areas"],  o.errors[:base]
    o.delete
  end

  it 'has the right equipment_names' do
    o = create_simple_observation
    another_equipment = FactoryBot.create(:equipment, :name => "Another Equipment")
    FactoryBot.create(:equipment, :name => "Evil Equipment")
    another_setup = o.setups.new(:equipment_id => another_equipment.id)
    another_setup.save
    expect(o.equipment_names).to eq "Equipment2, Another Equipment"
    o.delete
  end

  it 'gets the right materials_with_rates' do
    o = create_simple_observation
    activity = Activity.find_by(observation_id: o.id) ||
               FactoryBot.create(:activity, observation_id: o.id)
    equipment = Equipment.find_by_name('Another Equipment') ||
                FactoryBot.create(:equipment, name: 'Another Equipment')
    setup = activity.setups.new(equipment_id: equipment.id)
    assert setup.save
    material = Material.find_by_name('Material4') || FactoryBot.create(:material, name: 'Material4')
    unit = Unit.find_by_name('Unit4') || FactoryBot.create(:unit, name: 'Unit4')
    trans0 = setup.material_transactions.new(material_id: material.id, rate: 5, unit_id: unit.id)
    assert trans0.save
    assert_equal 'Material3: 4.0 Unit3s per acre, Material4: 5.0 Unit4s per acre',
                 o.materials_with_rates
    o.delete
  end

  it 'returns the right observation_type' do
    o = create_simple_observation
    assert_equal 'Soil Preparation', o.observation_type
    o.delete
  end

  # TODO: you should only be allowed to put an observation_type in once
  it 'gives all of the right observation_type_names' do
    o = create_simple_observation
    another_type = ObservationType.new(name: 'Another Type')
    assert another_type.save
    o.observation_types << another_type
    assert o.save
    o.reload
    assert_equal 'Soil Preparation, Another Type', o.observation_type_names
    o.delete
  end

  it 'accepts token ids in areas_as_text' do
    o = create_simple_observation
    text_areas = '3,415'
    o.areas_as_text = text_areas
    o.save
    a_leaf = Area.find(3).expand.first
    b_leaf = Area.find(415).expand.first
    assert o.areas.include?(a_leaf)
    assert o.areas.include?(b_leaf)
    o.delete
  end

  it 'gives the right material_names' do
    o = create_simple_observation
    activity = find_or_factory(:activity, observation_id: o.id)
    equipment = find_or_factory(:equipment, name: 'Another Equipment')
    setup = activity.setups.new(equipment_id: equipment.id)
    assert setup.save
    material = find_or_factory(:material, name: 'Material4')
    unit = find_or_factory(:unit, name: 'Unit4')
    trans0 = setup.material_transactions.new(material_id: material.id, rate: 5, unit_id: unit.id)
    assert trans0.save
    assert_equal %w[Material3 Material4], o.material_names
    o.delete
  end

  # TODO: This test, material_names, and materials_with_rates should be refactored
  it 'gives the right n_contents' do
    o = create_simple_observation
    activity = find_or_factory(:activity, observation_id: o.id)
    equipment = find_or_factory(:equipment, name: 'Another Equipment')
    setup = activity.setups.new(equipment_id: equipment.id)
    assert setup.save
    material = find_or_factory(:material, name: 'Material4')
    unit = find_or_factory(:unit, name: 'Unit4')
    trans0 = setup.material_transactions.new(material_id: material.id, rate: 5, unit_id: unit.id)
    assert trans0.save
    material = Material.find_by_name('Material3')
    material.n_content = 40
    material.save
    material = Material.find_by_name('Material4')
    material.n_content = 30
    material.save
    assert_includes(o.n_contents, 40)
    assert_includes(o.n_contents, 30)
    o.delete
  end

  it 'returns the right rates' do
    o = create_simple_observation
    activity = Activity.find_by(observation_id: o.id) ||
               FactoryBot.create(:activity, observation_id: o.id)
    # equipment = Equipment.find_by_name('Another Equipment') ||
    #             FactoryBot.create(:equipment, name: 'Another Equipment')
    equipment = find_or_factory(:equipment, name: 'Another Equipment')
    setup = activity.setups.new(equipment_id: equipment.id)
    assert setup.save
    material = Material.find_by_name('Material4') || FactoryBot.create(:material, name: 'Material4')
    unit = Unit.find_by_name('Unit4') || FactoryBot.create(:unit, name: 'Unit4')
    trans0 = setup.material_transactions.new(material_id: material.id, rate: 5, unit_id: unit.id)
    assert trans0.save
    assert_equal [4.0, 5.0], o.rates
    o.delete
  end

  it 'returns the right unit_names' do
    o = create_simple_observation
    # activity = FactoryBot.create(:activity, :observation_id => o.id)
    activity = find_or_factory(:activity, observation_id: o.id)
    equipment = Equipment.find_by(name: "Another Equipment") || FactoryBot.create(:equipment, name: "Another Equipment")
    setup = activity.setups.new(:equipment_id => equipment.id)
    assert setup.save
    material = Material.find_by_name("Material4") || FactoryBot.create(:material, :name => "Material4")
    unit = Unit.find_by_name("Unit4") || FactoryBot.create(:unit, :name => "Unit4")
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 5, :unit_id => unit.id)
    assert trans_0.save
    assert_equal ['Unit3', 'Unit4'], o.unit_names
    o.delete
  end

  it "allows observation date to be set easily" do
    o = create_simple_observation
    o.observation_date = "yesterday"
    assert_equal Date.today - 1.day, o.obs_date.to_date
    o.delete
  end

  private

  def create_simple_observation
    type = find_or_factory(:observation_type, name: 'Soil Preparation')
    assert type
    person1 = Person.find_by_sur_name('Sur1') || FactoryBot.create(:person, sur_name: 'Sur1')
    company = find_or_factory(:company)

    observation = Observation.new(observation_date: 'June 14, 2007', company_id: company.id)
    observation.person = person1
    observation.observation_types << type
    expect(observation).to be_valid
    assert observation.save
    person2 = Person.find_by_sur_name('Sur2') || FactoryBot.create(:person, sur_name: 'Sur2')
    activity = observation.activities.new(hours: 1, person_id: person2.id)
    assert activity.save
    equipment = Equipment.find_by_name('Equipment2') || FactoryBot.create(:equipment, name: 'Equipment2')
    setup = activity.setups.new
    setup.equipment = equipment
    assert setup.save
    material = Material.find_by_name('Material3') || FactoryBot.create(:material, name: 'Material3')
    unit = Unit.find_by_name('Unit3') || FactoryBot.create(:unit, name: 'Unit3')
    trans_0 = setup.material_transactions.new(:material_id => material.id, :rate => 4, :unit_id => unit.id)
    assert trans_0.save
    trans_1 = setup.material_transactions.new(:material_id => material.id, :rate => 4, :unit_id => unit.id)
    assert trans_1.save
    observation.reload

    observation
  end
end
