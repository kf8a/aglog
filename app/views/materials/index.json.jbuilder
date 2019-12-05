json.array! @materials do |material|
  json.call(material, :id, :name)
end
