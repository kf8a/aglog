#Lysimeter field
t =Treatment.find_or_create_by_name(:name=>'LYSIMETER_FIELD', :study_id=>9)
Area.find_or_create_by_name(:name=>'LYSIMETER_FIELD',
                            :treatment_id => t,
                            :study_id=>9,
                            :company_id=>1)

# Main Site
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
