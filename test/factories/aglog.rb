#Independent Factories

Factory.define :area do |a|
  
end

Factory.define :equipment do |e|

end

Factory.define :hazard do |h|
  
end

Factory.define :material do |m|
  
end

Factory.define :observation_type do |o|
  o.name    "Default"
end

Factory.define :person do |p|
  p.given_name  "Bob"
  p.sur_name "Dobolina"
end

Factory.define :unit do |u|

end


#Dependent Factories

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
  s.equipment         Equipment.first || Factory.create(:equipment)
end
