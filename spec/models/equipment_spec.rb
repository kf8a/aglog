require 'spec_helper'

describe Equipment do

  before(:each) do
    find_or_factory(:equipment)
  end

  it { should belong_to :company }
  it { should validate_presence_of :company}
  it 'should validate the uniqueness of the case insensitive name by scope' do
    name = 'tractor'
    company = find_or_factory(:company)
    equipment = find_or_factory(:equipment, :name => name, :company_id => company.id)

    equipment_with_same_name_and_company = company.equipment.new(:name=>name.upcase)
    equipment_with_same_name_different_company = Equipment.new(:name=>name)
    equipment_with_same_name_different_company.company = FactoryGirl.create(:company)

    equipment_with_same_name_different_company.save
    equipment_with_same_name_and_company.save

    equipment_with_same_name_and_company.errors[:name][0].should eq("has already been taken")
    equipment_with_same_name_different_company.errors[:name][0].should be_nil
  end

  #TODO what does this actually test?
  # I think this tests that we follow the right assocations. I'm not sure if that needs testing.
  it 'should grab all and only the right its own observations with self.observations' do
    @equipment = find_or_factory(:equipment, :name => 'correct equipment')

    included_observation_first = find_or_factory(:observation)
    activity = Activity.new
    activity.observation = included_observation_first
    FactoryGirl.create(:setup, :activity_id => activity.id, :equipment_id => @equipment.id)

    included_observation_second = FactoryGirl.create(:observation)
    activity = Activity.new(:activity)
    activity.observation = included_observation_second
    FactoryGirl.create(:setup, :activity_id => activity.id, :equipment_id => @equipment.id)

    equipment_2 = FactoryGirl.create(:equipment, :name => 'evil equipment')
    not_included_observation = FactoryGirl.create(:observation)
    activity = FactoryGirl.create(:activity, :observation_id => not_included_observation.id)
    FactoryGirl.create(:setup, :activity_id => activity.id, :equipment_id => equipment_2.id)

    @equipment.reload
    assert @equipment.observations.include?(included_observation_first)
    assert @equipment.observations.include?(included_observation_second)
    assert !@equipment.observations.include?(not_included_observation)
  end
end
