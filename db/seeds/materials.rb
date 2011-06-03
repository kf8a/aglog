Material.find_or_create_by_name(:name => 'nothing')
Material.find_or_create_by_name(:name => 'seed corn', :operation_type_id => 3)
Material.find_or_create_by_name(:name => 'seed wheat', :operation_type_id => 3)
Material.find_or_create_by_name(:name => '60-0-0', :operation_type_id => 4)
Material.find_or_create_by_name(:name => 'corn', :operation_type_id => 5)
Material.find_or_create_by_name(:name => 'wheat', :operation_type_id => 5)

Material.find(:all).each do |m|
  m.specific_weight = 1
  m.save
end
