json.areas @areas.roots do |area|
  json.id area.id
  json.name area.name
  json.description area.description
  if area.children
    json.areas do
      json.partial! partial: 'areas/area', collection: area.children, as: :area
    end
  end
end
