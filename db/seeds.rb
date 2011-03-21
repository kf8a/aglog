Study.find_or_create_by_name(:name => 'T', :description=> 'MAIN')
Study.find_or_create_by_name(:name => 'B', :description => 'Biodiversity')
Study.find_or_create_by_name(:name => 'F', :description => 'Fertility Gradient')
Study.find_or_create_by_name(:name => 'iF', :description => 'Irrigated Fertility Gradient')
Study.find_or_create_by_name(:name => 'RT', :description => 'Rotation Entry Point')
Study.find_or_create_by_name(:name => 'G', :description => 'GLBRC')
Study.find_or_create_by_name(:name => 'CE', :description => 'CES')

1.upto(6) do |rep|
  1.upto(8) do |treat|
    t = Treatment.find_or_create_by_name(:name => "T#{treat}",
                                         :treatment_number => treat,
                                         :study_id => 1)

    Area.find_or_create_by_name(:name => "T#{treat}R#{rep}", 
                                :treatment_id => t.id,
                                :replicate => rep, 
                                :company_id => 1,
                                :study_id => 1)
  end
end

Person.create(:given_name => 'Joe', :sur_name => 'Simmons')

#add biodiversity
1.upto(4) do |rep|
  1.upto(21) do |treat|
    t = Treatment.find_or_create_by_name(:name=>"B#{treat}",
                                         :treatment_number => treat,
                                         :study_id => 2)
    Area.find_or_create_by_name(:name => "B#{treat}R#{rep}", 
                                :treatment_id => t.id,
                                :replicate => rep, 
                                :company_id => 1,
                                :study_id => 2)
  end
end

#add N rate study
1.upto(4) do |rep|
  1.upto(9) do |treat|
    t = Treatment.find_or_create_by_name(:name => "F#{treat}",
                                         :treatment_number => treat,
                                        :study_id => 3)
    Area.find_or_create_by_name(:name => "F#{treat}R#{rep}", 
                                :replicate => rep, 
                                :treatment_id => t.id,
                                :company_id => 1,
                                :study_id => 3)
  end
end

#add irrigated N rate study
1.upto(4) do |rep|
  1.upto(9) do |treat|
    t = Treatment.find_or_create_by_name(:name=>"iF#{treat}",
                                         :treatment_number => treat,
                                        :study_id => 4)
    Area.find_or_create_by_name(:name => "iF#{treat}R#{rep}", 
                                :replicate => rep, 
                                :treatment_id => t.id,
                                :company_id => 1,
                                :study_id => 4)
  end
end

#GLBRC study
1.upto(5) do |rep|
  1.upto(10) do |trt|
    t = Treatment.find_or_create_by_name(:name=>"G#{trt}",
                                         :treatment_number => trt,
                                         :study_id => 6)
    Area.find_or_create_by_name(:name => "G#{trt}R#{rep}", 
                                :treatment_id => t.id,
                                :replicate => rep, 
                                :company_id => 1,
                                :study_id => 6)
  end
end


#CES study
1.upto(4) do |rep|
  plot = rep * 100
  1.upto(19) do |trt|
    t = Treatment.find_or_create_by_name(:name=>"CE#{trt}",
                                         :treatment_number => trt,
                                         :study_id => 7)
    Area.find_or_create_by_name(:name => "CE#{plot}", 
                                :treatment_id => t.id,
                                :replicate => rep,
                                :company_id => 1,
                                :study_id => 7)
    plot = plot + 1
  end
end

company = Company.find_or_create_by_name(:name=>'lter')

Equipment.find_or_create_by_name(:name => "John Deere 5220 Tractor",:is_tractor => true, :company_id=>company)
Equipment.find_or_create_by_name(:name => "Gandy Air Seeder", :use_material => true,:company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 7520 Tractor",  :is_tractor => true, :company=>company)
Equipment.find_or_create_by_name(:name => 'John Deere 714 Chisel plow', :company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 7420a Tractor",  :is_tractor => true, :company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 115 flail shredder", :company=>company)
Equipment.find_or_create_by_name(:name => "Top Air Sprayer", :use_material => true, :company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 726 soil finisher")
Equipment.find_or_create_by_name(:name => "John Deere 1730 Maxemerge Plus Planter", :use_material => true, :company=>company)
Equipment.find_or_create_by_name(:name => "Rotary Hoe", :company=>company)
Equipment.find_or_create_by_name(:name => 'Hay tedder', :company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 2155 Tractor", :is_tractor => true, :company=>company)
Equipment.find_or_create_by_name(:name => "New Holland Baler", :use_material => true, :company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 10' brushhog mower", :company=>company)
Equipment.find_or_create_by_name(:name => 'Willmar spreader', :use_material => true, :company=>company)
Equipment.find_or_create_by_name(:name => "John Deere 6420 Tractor", :is_tractor => true, :company=>company)
Equipment.find_or_create_by_name(:name => 'John Deere 6 Row Corn Harvester', :is_tractor => true, :company=>company)

Unit.find_or_create_by_name(:name => 'gram')
Unit.find_or_create_by_name(:name => 'kilogram', :si_unit_id => 1, :conversion_factor => 1000)
Unit.find_or_create_by_name(:name => 'bushel')
Unit.find_or_create_by_name(:name => 'metric ton')
Unit.find_or_create_by_name(:name => 'fluid ounce')
Unit.find_or_create_by_name(:name => 'ounce')
Unit.find_or_create_by_name(:name => 'quart')

Material.find_or_create_by_name(:name => 'nothing')
Material.find_or_create_by_name(:name => 'seed corn', :operation_type_id => 3)
Material.find_or_create_by_name(:name => 'seed wheat', :operation_type_id => 3)
Material.find_or_create_by_name(:name => '60-0-0', :operation_type_id => 4)
Material.find_or_create_by_name(:name => 'corn', :operation_type_id => 5)
Material.find_or_create_by_name(:name => 'wheat', :operation_type_id => 5)

ObservationType.find_or_create_by_name(:name => 'Soil Preparation')
ObservationType.find_or_create_by_name(:name => 'Harvest')
ObservationType.find_or_create_by_name(:name => 'Planting')
ObservationType.find_or_create_by_name(:name => 'Fertilizer application')
ObservationType.find_or_create_by_name(:name => 'Pesticide application')
ObservationType.find_or_create_by_name(:name => 'Herbicide application')

Material.find(:all).each do |m|
  m.specific_weight = 1
  m.save
end
