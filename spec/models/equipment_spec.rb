require 'rails_helper'

describe Equipment do

  it {is_expected.to have_many(:setups) }
  it {is_expected.to have_and_belong_to_many(:materials) }
  it { is_expected.to belong_to :company }
  it { is_expected.to validate_presence_of :company}
  it { is_expected.to have_many(:equipment_pictures)}

  it 'validates the uniqueness of the case insensitive name by scope' do
    name = 'tractor'
    company = find_or_factory(:company)
    equipment = find_or_factory(:equipment, :name => name, :company_id => company.id)

    equipment_with_same_name_and_company = company.equipment.new(:name=>name.upcase)
    equipment_with_same_name_different_company = Equipment.new(:name=>name)
    equipment_with_same_name_different_company.company = FactoryBot.create(:company)

    equipment_with_same_name_different_company.save
    equipment_with_same_name_and_company.save

    expect(equipment_with_same_name_and_company.errors[:name][0]).to eq("has already been taken")
    expect(equipment_with_same_name_different_company.errors[:name][0]).to be_nil
  end

end
