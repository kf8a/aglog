require 'rails_helper'

RSpec.describe Salus, :type => :model do
  before(:each) do
    @area = find_or_factory(:area)
    @salus = Salus.new
    @salus.area = @area
  end

  it 'returns fertilization components for the year' do
    create_fertilizer_observation
    result = "<Mgt_Fertilizer_App Year ='#{Date.today.year} DOY='#{Date.today.yday}' AKFer='' ANFer='' APFer=''/>"
    expect(@salus.fertilizer_components_for(Date.today.year)).to eq result
  end

  it 'returns tillage components for the year' do
    create_tillage_observation
    result = "<Mgt_Tillage_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' TDep='6' TImpl=''/>"
    expect(@salus.tillage_components_for(Date.today.year)).to eq result
  end

  it 'returns harvest components for the year' do
    obs = create_harvest_observation
    result = "<Mgt_Harvest_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' src='https://aglog.kbs.msu.edu/observations/#{obs.id}'/>"
    expect(@salus.harvest_components_for(Date.today.year)).to eq result
  end

  it 'does not return any components for an empty year' do
    expect(@salus.harvest_components_for(1900)).to eq ""
  end

  it 'returns a rotation component for the year' do
    create_fertilizer_observation
    obs = create_harvest_observation
    result = "\n<Mgt_Fertilizer_App Year ='#{Date.today.year} DOY='#{Date.today.yday}' AKFer='' ANFer='' APFer=''/>\n\n<Mgt_Harvest_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' src='https://aglog.kbs.msu.edu/observations/#{obs.id}'/>"
    expect(@salus.rotation_components_for(Date.today.year)).to eq  result
  end

  it "returns planting components for the year" do
    create_planting_observation
    # result = "<Mgt_Planting CropMod='S' SpeciesID='WH' CultivarID='IB1003' Year='#{Date.today.year}' DOY='#{Date.today.yday}' EYear='0' EDOY='' Ppop='400' Ppoe='400' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' />"
    result = "<Mgt_Planting CropMod='S' SpeciesID='corn' CultivarID='IB1003' Year='#{Date.today.year}' DOY='#{Date.today.yday}' EYear='0' EDOY='' Ppop='10' Ppoe='10' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' notes='' />"
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


  def create_planting_observation
    observation_type = ObservationType.where(name: "Planting").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    material_type = FactoryGirl.create :material_type, name: "seed"
    material = FactoryGirl.create :material, name: "corn", material_type_id: material_type.id
    material_transaction = FactoryGirl.create :material_transaction, material: material, rate: 10
    setup = FactoryGirl.create(:setup, {material_transactions: [material_transaction]})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

    @area.observations << observation
    observation
  end

  def create_tillage_observation
    observation_type = ObservationType.where(name: "Soil Preparation").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
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

  def create_fertilizer_observation
    observation_type = ObservationType.where(name: "Fertilizer application").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}

    material_type = FactoryGirl.create :material_type, name: "fertilizer"
    material = FactoryGirl.create :material, name: "urea", material_type_id: material_type.id, n_content: 30
    material_transaction = FactoryGirl.create :material_transaction, material: material, rate: 10
    setup = FactoryGirl.create(:setup, {material_transactions: [material_transaction]})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

    @area.observations << observation
    observation
  end

end
