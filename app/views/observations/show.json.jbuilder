json.id @observation.id
json.comment @observation.comment
json.obs_date @observation.obs_date

json.observation_types @observation.observation_types
json.areas_as_text @areas_as_text
json.areas @observation.areas do |area|
  json.name area.name
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
    json.equipment do
      json.id setup.equipment.id
      json.name setup.equipment.name
      json.use_material setup.equipment.use_material
    end
    json.material_transactions setup.material_transactions do |transaction|
      json.id transaction.id
      json.rate transaction.rate
      json.material do
        json.id transaction.material.id
        json.name transaction.material.name
      end

      json.unit do
        json.id transaction.unit.id
        json.name transaction.unit.name
      end
    end
  end
end
json.files @observation.notes.each do |note|
  json.name note.identifier
end
