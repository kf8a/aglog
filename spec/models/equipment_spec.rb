# frozen_string_literal: true

require 'rails_helper'

describe Equipment do
  it { is_expected.to have_many(:setups) }
  it { is_expected.to have_and_belong_to_many(:materials) }
  it { is_expected.to belong_to :company }
  it { is_expected.to validate_presence_of :company }
  it { is_expected.to have_many(:equipment_pictures) }

  it 'validates the uniqueness of the case insensitive name by scope' do
    name = 'tractor'
    company = find_or_factory(:company)
    find_or_factory(:equipment, name: name, company_id: company.id)

    with_same_name_and_company = company.equipment.new(name: name.upcase)
    with_same_name_different_company = Equipment.new(name: name)
    with_same_name_different_company.company = FactoryBot.build(:company)

    with_same_name_different_company.save
    with_same_name_and_company.save

    expect(with_same_name_and_company.errors[:name][0]).to eq('has already been taken')
    expect(with_same_name_different_company.errors[:name][0]).to be_nil
  end
end
