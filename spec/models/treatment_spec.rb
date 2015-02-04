require 'spec_helper'

describe Treatment do
  describe 'validate unique names' do
    it "should require unique name within a study" do
      t = Treatment.new(:study_id => 1, :name => 'T11')
      expect(t).to be_valid
      assert t.save

      t = Treatment.new(:study_id => 1, :name => 'T11')
      expect(t).to_not be_valid
    end
  end

  # context 'with valid study' do
  #   it "is valid" do
  #     t = Treatment.new(:study_id => 1)
  #     expect(t).to be_valid
  #   end
  #   context 'without valid study' do
  #     it 'is not valid' do
  #       t = Treatment.new(:study_id => 99)
  #       expect(t).to_not be_valid
  #     end
  #   end
  # end
end
