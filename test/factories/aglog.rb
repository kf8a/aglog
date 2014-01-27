FactoryGirl.define do

  sequence :sur_name do |n|
    "Doboline#{n}"
  end
  #Independent Factories

  factory :hazard do
  end

  factory :material_type do
  end

  factory :observation_type do
    name  "Default"
  end

  factory :company do
    name  "lter"
  end

  factory :study do
  end

  factory :treatment do
  end

  factory :unit do
  end

  #Dependent Factories

  factory :person do
    given_name  "Bob"
    sur_name
    company
  end

  factory :user do
    email    'bob@nospam.com'
    password 'testing'
    person
  end

  factory :area do
    association :company, factory: :company
  end

  factory :material do
    association :company, factory: :company
  end

  factory :equipment do
    association :company, factory: :company
  end

  factory :material_transaction do
    material
    # association :material, factory: :material
  end

  factory :observation do
    obs_date    Date.today
    observation_type
    person
    company
  end

  factory :activity do
    observation
    person
  end

  factory :setup do
    association :equipment, factory: :equipemnt
  end
end
