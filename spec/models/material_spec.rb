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
        it { expect(subject).to be_valid}
    end

    describe 'a material with the same name as another' do
      subject { Material.new(:name => @repeat_name) }
      it { expect(subject).to_not be_valid }
    end

    describe 'a material with the same name, different case as another' do
      subject { Material.new(:name => @repeat_name.upcase) }
      it { expect(subject).to_not be_valid }
    end

    describe 'a material with a different name' do
      subject { Material.new(:name => 'A New Material') }
      it { expect(subject).to be_valid() }
    end
  end

  describe "A material exists that is liquid. " do
    before(:each) do
      @material = Material.new(:name => 'liquid_material', :liquid => true)
    end

    context "to_mass(amount)" do
      it "should be the right number" do
        expect(@material.to_mass(4)).to eq(4000)
      end
    end
  end

  it 'should grab all and only the right its own observations with self.observations' do
    @material = FactoryGirl.create(:material, :name => 'correct material')

    included_observation_first = FactoryGirl.create(:observation)
    activity = FactoryGirl.create(:activity, :observation_id => included_observation_first.id)
    setup = FactoryGirl.create(:setup, :activity_id => activity.id)
    FactoryGirl.create(:material_transaction, :setup_id => setup.id, :material_id => @material.id)

    included_observation_second = FactoryGirl.create(:observation)
    activity = FactoryGirl.create(:activity, :observation_id => included_observation_second.id)
    setup = FactoryGirl.create(:setup, :activity_id => activity.id)
    FactoryGirl.create(:material_transaction, :setup_id => setup.id, :material_id => @material.id)

    evil_material = FactoryGirl.create(:material, :name => 'evil material')
    not_included_observation = FactoryGirl.create(:observation)
    activity = FactoryGirl.create(:activity, :observation_id => not_included_observation.id)
    setup = FactoryGirl.create(:setup, :activity_id => activity.id)
    FactoryGirl.create(:material_transaction, :setup_id => setup.id, :material_id => evil_material.id)

    @material.reload
    assert @material.observations.include?(included_observation_first)
    assert @material.observations.include?(included_observation_second)
    assert !@material.observations.include?(not_included_observation)
  end
end
