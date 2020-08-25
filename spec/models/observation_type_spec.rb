describe ObservationType do
  context 'require unique name' do
    before { @test_name = 'Harvest' } # in the fixure

    it 'does not allow a duplicate name' do
      observation = ObservationType.new(name: @test_name)
      expect(observation).to_not be_valid
    end

    it 'does not allow a duplicate case different name' do
      observation = ObservationType.new(name: @test_name.upcase)
      expect(observation).to_not be_valid
    end

    it 'allows a different name' do
      observation = ObservationType.new(name: 'A New ObservationType') # is new name
      expect(observation).to be_valid
    end
  end
end
