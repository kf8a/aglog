require 'rails_helper'

RSpec.describe Salus, :type => :model do
  before(:each) do
    @area = find_or_factory(:area)
    # observation = FactoryGirl.create :observation, {observation_types: []}
    # @planting = @area.observation << observation
    @salus = Salus.new
    @salus.area = @area
  end
  it "returns a list of planting dates" do
    expect(@salus.planting_records).to eq []
  end

  it "returns a list of harvest dates" do
    expect(@salus.harvest_records).to eq []
  end

  it "returns a list of tillage events" do
    expect(@salus.tillage_records).to eq []
  end
end
