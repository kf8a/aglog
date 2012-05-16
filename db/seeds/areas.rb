#Lysimeter field
t =Treatment.find_or_create_by_name(:name=>'LYSIMETER_FIELD', :study_id=>9)
lys_field = Area.find_or_create_by_name(:name=>'LYSIMETER_FIELD',
                            :treatment_id => t,
                            :study_id=>9,
                            :company_id=>1)

# Main Site
main = Area.find_or_create_by_name(:name => "T", :study_id => 1, :company_id => 1)
1.upto(6) do |rep|
  1.upto(8) do |treat|
    t = Treatment.find_or_create_by_name(:name => "T#{treat}",
                                         :study_id => 1)

    treatment_area = Area.find_or_create_by_name(:name => "T#{treat}",
                                                 :treatment_id => t.id,
                                                 :company_id => 1,
                                                 :study_id => 1)

    treatment_area.move_to_child_of(main)

    area = Area.find_or_create_by_name(:name => "T#{treat}R#{rep}",
                                :treatment_id => t.id,
                                :replicate => rep,
                                :company_id => 1,
                                :study_id => 1)

    area.move_to_child_of(treatment_area)
  end
end

#add biodiversity
biodiversity = Area.find_or_create_by_name(:name => 'B', :study_id => 2, :company_id => 1)
1.upto(4) do |rep|
  1.upto(21) do |treat|
    t = Treatment.find_or_create_by_name(:name=>"B#{treat}",
                                         :treatment_number => treat,
                                         :study_id => 2)

    treatment_area = Area.find_or_create_by_name(:name => "B#{treat}",
                                                 :treatment_id => t.id,
                                                 :company_id => 1,
                                                 :study_id => 2)
    treatment_area.move_to_child_of(biodiversity)

    area = Area.find_or_create_by_name(:name => "B#{treat}R#{rep}",
                                :treatment_id => t.id,
                                :replicate => rep,
                                :company_id => 1,
                                :study_id => 2)

    area.move_to_child_of(treatment_area)
  end
end

#add N rate study
n_rate = Area.find_or_create_by_name(:name => "F", :study_id => 3, :company_id => 1)
1.upto(4) do |rep|
  1.upto(9) do |treat|
    t = Treatment.find_or_create_by_name(:name => "F#{treat}",
                                        :study_id => 3)
    treatment_area = Area.find_or_create_by_name(:name => "F#{treat}",
                                                 :treatment_id => t.id,
                                                 :company_id => 1,
                                                 :study_id => 3)
    treatment_area.move_to_child_of(n_rate)

    area = Area.find_or_create_by_name(:name => "F#{treat}R#{rep}",
                                :replicate => rep,
                                :treatment_id => t.id,
                                :company_id => 1,
                                :study_id => 3)
    area.move_to_child_of(treatment_area)
  end
end

#add irrigated N rate study
irrigated_n_rate = Area.find_or_create_by_name(:name => "iF", :study_id => 4, :company_id => 1)
1.upto(4) do |rep|
  1.upto(9) do |treat|
    t = Treatment.find_or_create_by_name(:name=>"iF#{treat}",
                                        :study_id => 4)
    treatment_area = Area.find_or_create_by_name(:name => "iF#{treat}",
                                                 :treatment_id => t.id,
                                                 :company_id => 1,
                                                 :study_id => 4)
    treatment_area.move_to_child_of(irrigated_n_rate)

    area = Area.find_or_create_by_name(:name => "iF#{treat}R#{rep}",
                                :replicate => rep,
                                :treatment_id => t.id,
                                :company_id => 1,
                                :study_id => 4)
    area.move_to_child_of(treatment_area)
  end
end

#GLBRC study
glbrc = Area.find_or_create_by_name(:name => "G", :study_id => 6, :company_id => 1)
1.upto(5) do |rep|
  1.upto(10) do |trt|
    t = Treatment.find_or_create_by_name(:name=>"G#{trt}",
                                         :study_id => 6)
    treatment_area = Area.find_or_create_by_name(:name => "G#{trt}",
                                                 :treatment_id => t.id,
                                                 :company_id => 1,
                                                 :study_id => 6)
    treatment_area.move_to_child_of(glbrc)

    area = Area.find_or_create_by_name(:name => "G#{trt}R#{rep}",
                                :treatment_id => t.id,
                                :replicate => rep,
                                :company_id => 1,
                                :study_id => 6)
    area.move_to_child_of(treatment_area)
  end
end


#CES study
ces = Area.find_or_create_by_name(:name => "CE", :study_id => 7, :company_id => 1)
1.upto(4) do |rep|
  plot = rep * 100
  1.upto(19) do |trt|
    t = Treatment.find_or_create_by_name(:name=>"CE#{trt}",
                                         :study_id => 7)
    treatment_area = Area.find_or_create_by_name(:name => "CE#{trt}",
                                                 :treatment_id => t.id,
                                                 :company_id => 1,
                                                 :study_id => 7)
    treatment_area.move_to_child_of(ces)

    area = Area.find_or_create_by_name(:name => "CE#{plot}",
                                :treatment_id => t.id,
                                :replicate => rep,
                                :company_id => 1,
                                :study_id => 7)
    area.move_to_child_of(treatment_area)
    plot = plot + 1
  end
end

wicst = Area.find_or_create_by_name(:name => "WICST", :study_id => 8, :company_id => 1)
['ldp', 'hdp', 'sg'].each do |treatment_name|
  t = Treatment.find_or_create_by_name(:name=>treatment_name,
                                       :study_id => 8)
  treatment_area = Area.find_or_create_by_name(:name => treatment_name,
                                               :treatment_id => t.id,
                                               :company_id => 1,
                                               :study_id => 8)
  treatment_area.move_to_child_of(wicst)

  1.upto(3) do |rep|
    area = Area.find_or_create_by_name(:name => "#{treatment_name}R#{rep}",
                                :treatment_id => t.id,
                                :replicate => rep,
                                :company_id => 1,
                                :study_id => 8)
    area.move_to_child_of(treatment_area)
  end
end

#For some reason company is not being set in the above methods

company = Company.find_by_name('lter')
Area.all.each do |area|
  unless area.company
    area.company = company
    area.save
  end
end
