require 'spec_helper'

describe Material do
  describe "requires unique name: " do
    before(:each) do
      @repeat_name = 'seed corn'
      find_or_factory(:material, :name => @repeat_name)
    end

    it {should belong_to :company}

    describe 'an archived material' do
      subject { Material.new(:name => 'deprecated', :archived=> true) }
        it {should be_valid}
    end
    
    describe 'a material with the same name as another' do
      subject { Material.new(:name => @repeat_name) }
      it { should_not be_valid }
    end

    describe 'a material with the same name, different case as another' do
      subject { Material.new(:name => @repeat_name.upcase) }
      it { should_not be_valid }
    end

    describe 'a material with a different name' do
      subject { Material.new(:name => 'A New Material') }
      it { should be_valid }
    end
  end

  context "A material exists that is liquid. " do
    before(:each) do
      @material = find_or_factory(:material, :name => 'liquid_material', :liquid => true)
    end

    context "to_mass(amount)" do
      it "should be the right number" do
        assert_equal 4000, @material.to_mass(4)
      end
    end
  end

  it 'should grab all and only the right its own observations with self.observations' do
    @material = Factory.create(:material, :name => 'correct material')

    included_observation_first = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => included_observation_first.id)
    setup = Factory.create(:setup, :activity_id => activity.id)
    Factory.create(:material_transaction, :setup_id => setup.id, :material_id => @material.id)

    included_observation_second = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => included_observation_second.id)
    setup = Factory.create(:setup, :activity_id => activity.id)
    Factory.create(:material_transaction, :setup_id => setup.id, :material_id => @material.id)

    evil_material = Factory.create(:material, :name => 'evil material')
    not_included_observation = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => not_included_observation.id)
    setup = Factory.create(:setup, :activity_id => activity.id)
    Factory.create(:material_transaction, :setup_id => setup.id, :material_id => evil_material.id)

    @material.reload
    assert @material.observations.include?(included_observation_first)
    assert @material.observations.include?(included_observation_second)
    assert !@material.observations.include?(not_included_observation)
  end

  describe 'A material with a material type' do
    before(:each) do
      @material_type = Factory.create(:material_type, :name => 'Testable Name')
      @material = find_or_factory(:material, :name => 'material_type_material', :material_type_id => @material_type.id)
    end

    it 'should return the name of the material type on material_type_name' do
      assert_equal @material_type.name, @material.material_type_name
    end
  end

  describe 'An area with no study' do
    subject { Factory.create(:area, :study_id => nil) }
    its(:study_name) { should be_nil }
  end
end

