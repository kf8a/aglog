1.upto(7) do |treat|
  1.upto(6) do |rep|
    Area.new(:name => "T#{treat}R#{rep}", :treatment => treat, :replicate => rep).save
  end
end

Person.create(:given_name => 'Joe', :sur_name => 'Simmons')

#add biodiversity
1.upto(21) do |treat|
  1.upto(4) do |rep|
    Area.create(:name => "B#{treat}R#{rep}", :treatment => treat, :replicate => rep)
  end
end
#add N rate study
1.upto(9) do |treat|
  1.upto(4) do |rep|
    Area.create(:name => "F#{treat}R#{rep}", :treatment => treat, :replicate => rep)
  end
end

1.upto(4) do |t|
  1.upto(3) do  |e|
    1.upto(4)  do |r|
      Area.create(:name => "REPT#{t}E#{e}R#{r}", :replicate => "#{r}", :treatment => "#{t}#{e}")
    end
  end
end

#add irrigated N rate study
1.upto(9) do |treat|
  1.upto(4) do |rep|
    Area.create(:name => "iF#{treat}R#{rep}", :treatment => treat, :replicate => rep)
  end
end