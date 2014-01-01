require 'spec_helper'

describe Unit do
  describe 'name validations' do
      before(:each) do
        @test_name = 'ounce'
        @unit = Unit.new
      end

      it 'should not allow the same name' do
        @unit.name  = @test_name
        @unit.should_not be_valid
      end

      it 'should be case insensitive' do
        @unit.name = @test_name.upcase
        @unit.should_not be_valid
      end

      it 'allows different names' do
        @unit.name = 'a new unit'
        @unit.should be_valid
      end
  end
end
