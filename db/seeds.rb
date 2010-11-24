1.upto(7) do |treat|
  1.upto(6) do |rep|
    Area.find_or_create_by_name(:name => "T#{treat}R#{rep}", :treatment_number => treat, :replicate => rep)
  end
end

Person.create(:given_name => 'Joe', :sur_name => 'Simmons')

#add biodiversity
1.upto(21) do |treat|
  1.upto(4) do |rep|
    Area.find_or_create_by_name(:name => "B#{treat}R#{rep}", :treatment_number => treat, :replicate => rep)
  end
end

#add N rate study
1.upto(9) do |treat|
  1.upto(4) do |rep|
    Area.find_or_create_by_name(:name => "F#{treat}R#{rep}", :treatment_number => treat, :replicate => rep)
  end
end

1.upto(4) do |t|
  1.upto(3) do  |e|
    1.upto(4)  do |r|
      Area.find_or_create_by_name(:name => "REPT#{t}E#{e}R#{r}", :replicate => "#{r}", :treatment_number => "#{t}#{e}")
    end
  end
end

#add irrigated N rate study
1.upto(9) do |treat|
  1.upto(4) do |rep|
    Area.find_or_create_by_name(:name => "iF#{treat}R#{rep}", :treatment_number => treat, :replicate => rep)
  end
end