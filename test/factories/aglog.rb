FactoryGirl.define do

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
    sur_name    "Dobolina"
    company     Company.first || FactoryGirl.create(:company)
  end

  factory :area do
    company     Company.first || FactoryGirl.create(:company)
  end

  factory :material do
    company     Company.first || FactoryGirl.create(:company)
  end

  factory :equipment do
    company
  end

  factory :material_transaction do
    material    Material.first || FactoryGirl.create(:material)
  end

  factory :observation do
    obs_date            Date.today
    observation_types   [ObservationType.first || FactoryGirl.create(:observation_type)]
    person              Person.first || FactoryGirl.create(:person)
  end

  factory :activity do
    observation         Observation.first || FactoryGirl.create(:observation)
    person              Person.first || FactoryGirl.create(:person)
  end

  factory :setup do
    equipment
  end
end
