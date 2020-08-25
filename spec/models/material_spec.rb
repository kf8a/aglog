# frozen_string_literal: true

describe Material do
  describe 'a valid material' do
    describe 'an archived material' do
      subject { Material.new(name: 'deprecated', archived: true) }
      it { expect(subject).to be_valid }
    end

    context 'names are unique' do
      before(:each) do
        @repeat_name = 'seed corn'
        company = find_or_factory(:company, name: 'lter')
        @other_material = Material.where(name: @repeat_name, company: company).first_or_create
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
        it { expect(subject).to be_valid }
      end
    end

    describe 'A material exists that is liquid. ' do
      before(:each) { @material = Material.new(name: 'liquid_material', liquid: true) }

      context 'to_mass(amount)' do
        it 'has the right number' do
          expect(@material.to_mass(4)).to eq(4)
        end
        it 'uses the specific weight' do
          @material.specific_weight = 2
          expect(@material.to_mass(4)).to eq(8)
        end
      end
    end
  end
end
