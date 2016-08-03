json.id @observation.id
json.comment @observation.comment
json.obs_date @observation.obs_date

json.observation_types ObservationType.all.each do |type|
  json.id type.id
  json.name type.name
  json.checked true if @observation.observation_types.include?(type)
end
json.areas_as_text @areas_as_text
json.areas @observation.areas do |area|
  json.area area
  json.id area.id
end
json.activities @observation.activities do |activity|
  json.id activity.id
  json.person do
    json.id activity.person.id
    json.name activity.person.name
  end
  json.setups activity.setups do |setup|
    json.id setup.id
    json.equipment setup.equipment
    json.material_transactions setup.material_transactions do |transaction|
      json.id transaction.id
      json.amount transaction.rate
      json.material transaction.material
      json.unit transaction.unit
    end
  end
end

# should I create new templates here?

# TODO: scope by company id
json.people Person.all.each do |person|
  json.id person.id
  json.name person.name
end

json.equipment Equipment.all.each do |e|
  json.id e.id
  json.name e.name
end

json.materials Material.all.each do |m|
  json.id m.id
  json.name m.name
end

json.units Unit.all.each do |u|
  json.id u.id
  json.name u.name
end
