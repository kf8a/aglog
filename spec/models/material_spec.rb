require 'rails_helper'

describe Material do
  it {should have_many(:setups) }
  it {should have_many(:material_transactions) }
  it {should validate_presence_of :name }

  describe "requires unique name: " do
    before(:each) do
      @repeat_name = 'seed corn'
      find_or_factory(:material, name: @repeat_name, company_id: 1)
    end

    it {should belong_to :company}

    describe 'an archived material' do
      subject { Material.new(name: 'deprecated', archived: true) }
        it { expect(subject).to be_valid}
    end

    describe 'a material with the same name as another' do
      subject { Material.new(name: @repeat_name) }
      it { expect(subject).to_not be_valid }
    end

    describe 'a material with the same name, different case as another' do
      subject { Material.new(name: @repeat_name.upcase) }
      it { expect(subject).to_not be_valid }
    end

    describe 'a material with a different name' do
      subject { Material.new(name: 'A New Material') }
      it { expect(subject).to be_valid() }
    end

    describe "a material in a different company" do
      subject {Material.new(name: @repeat_name, company_id: 2) }
      it {expect(subject).to be_valid }
    end
  end

  describe "A material exists that is liquid. " do
    before(:each) do
      @material = Material.new(name: 'liquid_material', liquid: true)
    end

    context "to_mass(amount)" do
      it "should be the right number" do
        expect(@material.to_mass(4)).to eq(4000)
      end
    end
  end

end
