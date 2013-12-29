Material.find_or_create_by(:name => 'nothing')
Material.find_or_create_by(:name => 'seed corn', :operation_type_id => 3)
Material.find_or_create_by(:name => 'seed wheat', :operation_type_id => 3)
Material.find_or_create_by(:name => '60-0-0', :operation_type_id => 4)
Material.find_or_create_by(:name => 'corn', :operation_type_id => 5)
Material.find_or_create_by(:name => 'wheat', :operation_type_id => 5)

Material.all.each do |m|
  m.specific_weight = 1
  m.save
end
