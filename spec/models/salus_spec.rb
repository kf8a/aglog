require 'rails_helper'

RSpec.describe Salus, :type => :model do
  before(:each) do
    @area = find_or_factory(:area)
    @salus = Salus.new
    @salus.area = @area
  end

  it 'returns planting components for the year' do
  end

  it 'returns fertilization components for the year' do
    observation_type = ObservationType.where(name: "Fertilizer application").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    equipment = FactoryGirl.create :equipment
    setup = FactoryGirl.create(:setup, {equipment: equipment})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

    @area.observations << observation
  end

  it 'returns tillage components for the year' do
    observation_type = ObservationType.where(name: "Soil Preparation").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    equipment = FactoryGirl.create :equipment
    setup = FactoryGirl.create(:setup, {equipment: equipment})
    observation.activities =[FactoryGirl.create(:activity, {setups: [setup]})]

    @area.observations << observation
    result = "<Mgt_Tillage_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' TDep='6' TImpl=''/>"
    expect(@salus.tillage_records_for(Date.today.year)).to eq [observation]
  end

  it 'returns harvest components for the year' do
    observation_type = ObservationType.where(name: "Harvest").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    @area.observations << observation
    result = "<Mgt_Harvest_App Year='#{Date.today.year}' DOY='#{Date.today.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' />"
    expect(@salus.harvest_components_for(Date.today.year)).to eq result
  end

  it 'returns a rotation component for the year' do
   expect(@salus.rotation_components_for(2015)).to_not be_nil
  end

  it 'returns a list of operations on the field in chronological order' do
    # it starts out in an undefined state and then proceeds from tillage to planting to harvest
  end

  it "returns planting components for the year" do
    create_planting_observation.first
    # result = "<Mgt_Planting CropMod='S' SpeciesID='WH' CultivarID='IB1003' Year='#{Date.today.year}' DOY='#{Date.today.yday}' EYear='0' EDOY='' Ppop='400' Ppoe='400' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' />"
    result = "<Mgt_Planting CropMod='S' SpeciesID='corn' CultivarID='IB1003' Year='#{Date.today.year}' DOY='#{Date.today.yday}' EYear='0' EDOY='' Ppop='10' Ppoe='10' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' notes='' />"
    expect(@salus.planting_components_for(Date.today.year)).to eq result
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
  end
end
