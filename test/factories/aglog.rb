FactoryBot.define do
  sequence :sur_name do |n|
    "Doboline#{n}"
  end

  sequence :unit_name do |n|
    "Unit#{n}"
  end
  # Independent Factories

  factory :hazard do
  end

  factory :material_type do
  end

  factory :equipment_type do
  end

  factory :observation_type do
    name  { 'Default' }
  end

  factory :company do
    name  { 'lter' }
  end

  factory :study do
  end

  factory :treatment do
  end

  factory :unit do
    name  {generate(:unit_name)}
  end

  # Dependent Factories

  factory :membership do
    person
    company
  end

  factory :person do
    given_name { 'Bob'}
    sur_name
    transient do
      company_count { 1 }
    end
    after :create do |person, evaluator|
      create_list :membership, evaluator.company_count, person: person
    end
  end

  factory :user do
    email    { 'bob@nospam.com' }
    password { 'testing' }
    person
  end

  factory :area do
    company
  end

  factory :material do
    material_type
    company
  end

  factory :equipment do
    company
  end

  factory :material_transaction do
    material
  end

  factory :observation do
    obs_date { Date.today }
    # observation_types
    person
    company
  end

  factory :activity do
    # observation
    person
  end

  factory :setup do
    activity
    equipment
  end
end
