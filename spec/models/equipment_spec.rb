require 'spec_helper'

describe Equipment do

  before(:each) do
    find_or_factory(:equipment)
  end

  it {should belong_to :company }
  it { should validate_presence_of :company}
  it 'should validate the uniquenes of the case insensitive name by scope' do
    name = 'tractor'
    company = find_or_factory(:company)
    equipment = find_or_factory(:equipment, :name => name, :company_id => company)

    equipment_with_same_name_and_company = Equipment.new(:name=>name.upcase)
    equipment_with_same_name_and_company.company = company
    equipment_with_same_name_different_company = Equipment.new(:name=>name)
    equipment_with_same_name_different_company.company = Factory.create(:company)
    equipment_with_same_name_different_company.save
    equipment_with_same_name_and_company.save
    
    assert_equal "has already been taken", equipment_with_same_name_and_company.errors[:name][0]
    assert_nil equipment_with_same_name_different_company.errors[:name][0]
  end

  it 'should grab all and only the right its own observations with self.observations' do
    @equipment = find_or_factory(:equipment, :name => 'correct equipment')

    included_observation_first = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => included_observation_first.id)
    Factory.create(:setup, :activity_id => activity.id, :equipment_id => @equipment.id)

    included_observation_second = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => included_observation_second.id)
    Factory.create(:setup, :activity_id => activity.id, :equipment_id => @equipment.id)

    equipment_2 = Factory.create(:equipment, :name => 'evil equipment')
    not_included_observation = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => not_included_observation.id)
    Factory.create(:setup, :activity_id => activity.id, :equipment_id => equipment_2.id)

    @equipment.reload
    assert @equipment.observations.include?(included_observation_first)
    assert @equipment.observations.include?(included_observation_second)
    assert !@equipment.observations.include?(not_included_observation)
  end
end

