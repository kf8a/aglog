if Factory.factories.blank? #prevent redefining these factories

  #Independent Factories

  Factory.define :hazard do |h|

  end

  Factory.define :material_type do |m|
    
  end

  Factory.define :observation_type do |o|
    o.name    "Default"
  end

  Factory.define :company do |c|
    c.name    'lter'
  end

  Factory.define :study do |s|
    
  end

  Factory.define :treatment do |t|
    
  end

  Factory.define :unit do |u|

  end


  #Dependent Factories
  
  Factory.define :person do |p|
    p.given_name  "Bob"
    p.sur_name    "Dobolina"
    p.association :company, :factory => :company
  end

  Factory.define :area do |a|
    a.association :company, :factory => :company
  end

  Factory.define :material do |m|
    m.association :company, :factory => :company
  end

  Factory.define :equipment do |e|
    e.association :company, :factory => :company
  end

  Factory.define :activity do |a|
    a.person              Person.first || Factory.create(:person)
  end

  Factory.define :material_transaction do |m|
    m.material          Material.first || Factory.create(:material)
  end

  Factory.define :observation do |o|
    o.obs_date            Date.today
    o.observation_types   [ObservationType.first || Factory.create(:observation_type)]
    o.person              Person.first || Factory.create(:person)
  end

  Factory.define :setup do |s|
    s.association :equipment, :factory => :equipment
  end

end
