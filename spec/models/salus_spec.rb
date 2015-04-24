require 'rails_helper'

RSpec.describe Salus, :type => :model do
  before(:each) do
    @area = find_or_factory(:area)
    @salus = Salus.new
    @salus.area = @area
  end

  describe 'a continous sequence of rotation components' do
    before(:each) do
      create_tillage_observation(Date.today - 20)
      create_fertilizer_observation(Date.today - 10)
      create_planting_observation(Date.today - 5)
      create_harvest_observation
      create_tillage_observation(Date.today + 10)
      create_planting_observation(Date.today + 20)
      create_fertilizer_observation(Date.today + 30)
      create_harvest_observation(Date.today + 40)
    end

    it 'has 8 observations' do
      expect(@salus.records.size).to eq 8
    end

    it 'has two rotation components' do
      expect(@salus.rotation_components.size).to eq 2
    end
  end

  it 'returns fertilization components for the year' do
    obs = create_fertilizer_observation
    result = "<Mgt_Fertilizer_App Year ='#{Date.today.year} DOY='#{Date.today.yday}' AKFer='' ANFer='' APFer='' src='https://aglog.kbs.msu.edu/observations/#{obs.id}' notes=''/>"
    expect(@salus.fertilizer_components_for(Date.today.year)).to eq result
  end

  it 'returns tillage components for the year' do
    obs = create_tillage_observation
    result = "<Mgt_Tillage_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' TDep='6' TImpl='' src='https://aglog.kbs.msu.edu/observations/#{obs.id}' notes=''/>"
    expect(@salus.tillage_components_for(Date.today.year)).to eq result
  end

  it 'returns harvest components for the year' do
    obs = create_harvest_observation
    result = "<Mgt_Harvest_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' src='https://aglog.kbs.msu.edu/observations/#{obs.id}' notes=''/>"
    expect(@salus.harvest_components_for(Date.today.year)).to eq result
  end

  it 'does not return any components for an empty year' do
    expect(@salus.harvest_components_for(1900)).to eq ""
  end

  it 'returns a rotation component for the year' do
    obs1 = create_fertilizer_observation
    obs2 = create_harvest_observation
    result = "\n<Mgt_Fertilizer_App Year ='#{Date.today.year} DOY='#{Date.today.yday}' AKFer='' ANFer='' APFer='' src='https://aglog.kbs.msu.edu/observations/#{obs1.id}' notes=''/>\n\n<Mgt_Harvest_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' src='https://aglog.kbs.msu.edu/observations/#{obs2.id}' notes=''/>"
    expect(@salus.rotation_components_for(Date.today.year)).to eq  result
  end

  it "returns planting components for the year" do
    obs = create_planting_observation
    result = "<Mgt_Planting CropMod='S' SpeciesID='' CultivarID='IB1003' Year='#{Date.today.year}' DOY='#{Date.today.yday}' EYear='0' EDOY='' Ppop='10' Ppoe='10' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' src='https://aglog.kbs.msu.edu/observations/#{obs.id}' notes='' />"
    expect(@salus.planting_components_for(Date.today.year)).to eq result
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
    material_type = FactoryGirl.create :material_type, name: "seed"
    material = FactoryGirl.create :material, name: "corn", material_type_id: material_type.id
    material_transaction = FactoryGirl.create :material_transaction, material: material, rate: 10
    setup = FactoryGirl.create(:setup, {material_transactions: [material_transaction]})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

    @area.observations << observation
    observation
  end

  def create_tillage_observation(date=Date.today)
    observation_type = ObservationType.where(name: "Soil Preparation").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type], obs_date: date}
    equipment = FactoryGirl.create :equipment
    setup = FactoryGirl.create(:setup, {equipment: equipment})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

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

    material_type = FactoryGirl.create :material_type, name: "fertilizer"
    material = FactoryGirl.create :material, name: "urea", material_type_id: material_type.id, n_content: 30
    material_transaction = FactoryGirl.create :material_transaction, material: material, rate: 10
    setup = FactoryGirl.create(:setup, {material_transactions: [material_transaction]})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

    @area.observations << observation
    observation
  end

end
