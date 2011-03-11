Study.find_or_create_by_name(:name => 'MAIN')
Study.find_or_create_by_name(:name => 'Biodiversity')
Study.find_or_create_by_name(:name => 'Fertility Gradient')
Study.find_or_create_by_name(:name => 'Irrigated Fertility Gradient')
Study.find_or_create_by_name(:name => 'Rotation Entry Point')
Study.find_or_create_by_name(:name => 'GLBRC')
Study.find_or_create_by_name(:name => 'CES')

1.upto(8) do |treat|
  1.upto(6) do |rep|
    Area.find_or_create_by_name(:name => "T#{treat}R#{rep}", :treatment_number => treat, :replicate => rep, :study_id => 1)
  end
end

Person.create(:given_name => 'Joe', :sur_name => 'Simmons')

#add biodiversity
1.upto(21) do |treat|
  1.upto(4) do |rep|
    Area.find_or_create_by_name(:name => "B#{treat}R#{rep}", :treatment_number => treat, :replicate => rep, :study_id => 2)
  end
end

#add N rate study
1.upto(9) do |treat|
  1.upto(4) do |rep|
    Area.find_or_create_by_name(:name => "F#{treat}R#{rep}", :treatment_number => treat, :replicate => rep, :study_id => 3)
  end
end

1.upto(4) do |t|
  1.upto(3) do  |e|
    1.upto(4)  do |r|
      Area.find_or_create_by_name(:name => "REPT#{t}E#{e}R#{r}", :replicate => "#{r}", :treatment_number => "#{t}#{e}", :study_id => 5)
    end
  end
end

#add irrigated N rate study
1.upto(9) do |treat|
  1.upto(4) do |rep|
    Area.find_or_create_by_name(:name => "iF#{treat}R#{rep}", :treatment_number => treat, :replicate => rep, :study_id => 4)
  end
end

#GLBRC study
1.upto(4) do |r|
  Area.find_or_create_by_name(:name => "G1R#{r}", :treatment_number => 1, :replicate => r, :study_id => 6)
end

1.upto(10) do |t|
  Area.find_or_create_by_name(:name => "G#{t}", :treatment_number => t, :study_id => 6)
end

#CES study
1.upto(19) do |t|
  Area.find_or_create_by_name(:name => "CE#{t}", :treatment_number => t, :study_id => 7)
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

Study.find_or_create_by_name(:name => 'MAIN')
Study.find_or_create_by_name(:name => 'Biodiversity')
Study.find_or_create_by_name(:name => 'Fertility Gradient')
Study.find_or_create_by_name(:name => 'Irrigated Fertility Gradient')
Study.find_or_create_by_name(:name => 'Rotation Entry Point')

Material.find(:all).each do |m|
  m.specific_weight = 1
  m.save
end
