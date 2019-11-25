# frozen_string_literal: true

describe Unit do
  describe 'name validations' do
    before(:all) do
      Unit.new(name: 'ounce').save

      @unit = Unit.new
      @test_name = 'ounce'
    end

    it 'does not allow the same name' do
      @unit.name = @test_name
      expect(@unit).to_not be_valid
    end

    it 'is case insensitive' do
      @unit.name = @test_name.upcase
      expect(@unit).to_not be_valid
    end

    it 'allows different names' do
      @unit.name = 'a new unit'
      expect(@unit).to be_valid
    end
  end
end
