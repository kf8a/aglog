json.id @observation.id
json.comment @observation.comment
json.obs_date @observation.obs_date

json.observation_types ObservationType.all.each do |type|
  json.id type.id
  json.name type.name
  if @observation.observation_types.include?(type)
    json.checked true
  end
end
json.areas_as_text @areas_as_text
json.areas @observation.areas do |area|
  json.area area
  json.id = area.id
end
json.activities @observation.activities do |activity|
  json.activity activity
  json.person activity.person
  json.setups activity.setups do |setup|
    json.equipment setup.equipment
    json.material_transactions setup.material_transactions do |transaction|
      json.material transaction.material
    end
  end
end
