require 'spec_helper'

describe ObservationType do
  context 'require unique name' do
    before do
      @test_name = 'Harvest'
    end

    it "does not allow a duplicate name" do
      observation  = ObservationType.new(:name => @test_name) # is in fixture already
      observation.should_not be_valid
    end

    it 'does not allow a duplicate case different name' do
      observation  = ObservationType.new(:name => @test_name.upcase) # case insensitive
      observation.should_not be_valid
    end

    it 'allows a different name' do
      observation = ObservationType.new(:name => 'A New ObservationType') # is new name
      observation.should be_valid
    end
  end
end
