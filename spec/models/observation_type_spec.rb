require 'spec_helper'

describe ObservationType do
  context 'require unique name' do
    before do
      @test_name = 'Harvest'
      FactoryGirl.create(:observation_type, :name => @test_name)
    end

    it "does not allow a duplicate name" do
      observation  = ObservationType.new(:name => @test_name)
      observation.should_not be_valid
    end

    it 'does not allow a duplicate case different name' do
      observation  = ObservationType.new(:name => @test_name.upcase)
      observation.should_not be_valid
    end

    it 'allows a different name' do
      observation = ObservationType.new(:name => 'A New ObservationType') # is new name
      observation.should be_valid
    end
  end
end
