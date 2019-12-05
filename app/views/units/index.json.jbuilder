json.array! @units do |unit|
  json.call(unit, :id, :name)
end
