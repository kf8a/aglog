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

Factory.define :observation do |o|
  o.obs_date            Date.today
  o.observation_types   [ObservationType.first || Factory.create(:observation_type)]
  o.person              Person.first || Factory.create(:person)
end

Factory.define :unit do |u|
  
end
