describe Unit do
  describe 'name validations' do
      before(:each) do
        @test_name = 'ounce'
        @unit = Unit.new
      end

      it 'does not allow the same name' do
        @unit.name  = @test_name
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
