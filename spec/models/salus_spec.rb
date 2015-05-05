require 'rails_helper'

RSpec.describe Salus, :type => :model do
  before(:each) do
    @area = find_or_factory(:area)
    @salus = Salus.new
    @salus.area = @area
  end

  describe 'a fertilizer and planting observation' do
    it 'has the right planting population' do
      obs = create_fertilizer_and_planting_observation
      expect(@salus.planting_component(obs)).to include ppop: 12.35
    end
  end

  describe 'a planting and fertilizer observation' do
    it 'has the right fertilizer record' do
      obs = create_planting_and_fertilizer_observation
      expect(@salus.fertilizer_component(obs)).to include n_rate: 40.28
    end
  end

  describe 'a liquid fertilizer observation' do
    it 'should return the right n amount' do
      obs = create_liquid_fertilizer_observation
      expect(@salus.fertilizer_component(obs)).to include n_rate: 50.19
    end
  end

  describe 'a continous sequence of rotation components' do
    before(:each) do
      create_tillage_observation(Date.today - 20)
      create_fertilizer_observation(Date.today - 10)
      create_planting_observation(Date.today - 5)
      create_harvest_observation
      create_fertilizer_observation(Date.today + 5)
      create_tillage_observation(Date.today + 10)
      create_planting_observation(Date.today + 20)
      create_fertilizer_observation(Date.today + 30)
      create_harvest_observation(Date.today + 40)
    end

    it 'has 8 observations' do
      expect(@salus.records.size).to eq 9
    end

    it 'has two rotation components' do
      expect(@salus.rotation_components.size).to eq 2
    end

    it 'has 4 observations in the first rotation component' do
      expect(@salus.rotation_components.first.size).to eq 4
    end

    it 'has 5 observations in the second rotation component' do
      expect(@salus.rotation_components.second.size).to eq 5
    end
  end

  it 'returns an range of years' do
    year = Date.today.year
    create_harvest_observation(Date.today -  366)
    create_harvest_observation(Date.today -  766)
    create_harvest_observation(Date.today)

    expect(@salus.years).to eq (year -2) ... year
  end

  it 'returns the crop for the year' do
    create_planting_observation
    expect(@salus.crop_for(Date.today.year)).to eq 'corn'
  end

  def create_planting_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Planting").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}

    setup = FactoryGirl.create(:setup, {material_transactions: [planting_transaction]})
    activity = FactoryGirl.create(:activity, {setups: [setup]})
    observation.activities =[activity]

    @area.observations << observation
    observation
  end

  def create_tillage_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Soil Preparation").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}
    equipment = FactoryGirl.create :equipment
    setup = FactoryGirl.create(:setup, {equipment: equipment})
    activity = FactoryGirl.create(:activity, {setups: [setup]})
    observation.activities =[activity]

    @area.observations << observation
    observation
  end

  def create_harvest_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Harvest").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}

    @area.observations << observation
    observation
  end

  def create_fertilizer_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Fertilizer application").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}

    setup = FactoryGirl.create(:setup, {material_transactions: [fertilizer_transaction]})
    activity = FactoryGirl.create(:activity, {setups: [setup]})
    observation.activities =[activity]

    @area.observations << observation
    observation
  end


  def create_liquid_fertilizer_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Fertilizer application").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}

    unit = FactoryGirl.create :unit, conversion_factor: 3780
    material_type = FactoryGirl.create :material_type, name: "fertilizer"
    material = FactoryGirl.create :material, name: "urea", material_type_id: material_type.id, n_content: 28, liquid: true, specific_weight: 1.28
    material_transaction = FactoryGirl.create :material_transaction, material: material, rate: 15, unit: unit
    setup = FactoryGirl.create(:setup, {material_transactions: [material_transaction]})
    activity = FactoryGirl.create(:activity, {setups: [setup]})
    observation.activities =[activity]

    @area.observations << observation
    observation
  end

  def create_fertilizer_and_planting_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Fertilizer application").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}

    setup = FactoryGirl.create :setup
    setup.material_transactions << fertilizer_transaction
    setup.material_transactions << planting_transaction

    activity = FactoryGirl.create(:activity, {setups: [setup]})
    observation.activities =[activity]

    @area.observations << observation
    observation
  end

  def fertilizer_transaction
    unit = FactoryGirl.create :unit, conversion_factor: 453
    material_type = FactoryGirl.create :material_type, name: "fertilizer"
    material = FactoryGirl.create :material, name: "urea", material_type_id: material_type.id, n_content: 30
    FactoryGirl.create :material_transaction, material: material, rate: 120, unit: unit
  end

  def planting_transaction
    material_type = FactoryGirl.create :material_type, name: "seed"
    seed = FactoryGirl.create :material, name: "urea", material_type_id: material_type.id
    seeds = find_or_factory(:unit, name: "seeds")
    FactoryGirl.create :material_transaction, material: seed, rate: 50000, unit: seeds
  end

  def create_planting_and_fertilizer_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Fertilizer application").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}

    setup = FactoryGirl.create :setup
    setup.material_transactions << planting_transaction
    setup.material_transactions << fertilizer_transaction

    activity = FactoryGirl.create(:activity, {setups: [setup]})
    observation.activities =[activity]

    @area.observations << observation
    observation
  end

end
