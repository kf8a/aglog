require 'spec_helper'

describe Equipment do

  it {should have_many(:setups) }
  it {should have_and_belong_to_many(:materials) }
  it { should belong_to :company }
  it { should validate_presence_of :company}
  it { should have_many(:equipment_pictures)}

  it 'should validate the uniqueness of the case insensitive name by scope' do
    name = 'tractor'
    company = find_or_factory(:company)
    equipment = find_or_factory(:equipment, :name => name, :company_id => company.id)

    equipment_with_same_name_and_company = company.equipment.new(:name=>name.upcase)
    equipment_with_same_name_different_company = Equipment.new(:name=>name)
    equipment_with_same_name_different_company.company = FactoryGirl.create(:company)

    equipment_with_same_name_different_company.save
    equipment_with_same_name_and_company.save

    equipment_with_same_name_and_company.errors[:name][0].should eq("has already been taken")
    equipment_with_same_name_different_company.errors[:name][0].should be_nil
  end

end
