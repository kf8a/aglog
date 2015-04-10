require 'rails_helper'

RSpec.describe Salus, :type => :model do
  before(:each) do
    @area = find_or_factory(:area)
    @salus = Salus.new
    @salus.area = @area
  end

  it 'returns a list of operations on the field in chronological order' do
    # it starts out in an undefined state and then proceeds from tillage to planting to harvest
  end

  it "returns a list of planting dates" do
    # observation_type = ObservationType.where(name: "Planting").first
    # material_type = FactoryGirl.create :material_type, name: "seed"
    # material = FactoryGirl.create :material, name: "corn", material_type_id: material_type.id
    # observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    # @area.observations << observation
    # expect(@salus.planting_records).to eq [observation]
  end

  it "returns a list of harvest dates" do
    observation_type = ObservationType.where(name: "Harvest").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    @area.observations << observation
    expect(@salus.harvest_records).to eq [observation]
  end

  it "returns a list of tillage events" do
    observation_type = ObservationType.where(name: "Soil Preparation").first
    observation = FactoryGirl.create :observation, {observation_types: [observation_type]}
    @area.observations << observation
    expect(@salus.tillage_records).to eq [observation]
  end
end
