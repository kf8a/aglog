require 'test_helper'
require 'set'

class AreaTest < ActiveSupport::TestCase
  fixtures :areas, :studies, :treatments
  
  def test_uniqueness
    num_of_areas =  Area.count()
    a  = Area.new(:name => 'T1R1') # is in fixture already
    assert !a.save
    assert !a.errors.empty?
    
    a  = Area.new(:name => 't1r1') # case insensitive
    assert !a.save
    assert !a.errors.empty?
    
    a = Area.new(:name => 'T1R11', :study_id => 1) # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_areas + 1, Area.count
  end
  
  def test_study_exists
  	# area with good study
  	a = Area.new(:study_id => 1)
  	assert a.save
  	# area with invalid study
  	a = Area.new(:study_id => 99)
  	assert !a.save
  	# area without study is OK
  	a = Area.new(:name => 'area without study')
  	assert a.save  	
	end
	
	def test_treatment_requires_study
		a = Area.new(:study_id => 1, :treatment_id => 99)
		assert a.save
		a = Area.new(:treatment_id => 1)
		assert !a.save
	end
  
  def test_parse
  	# should highlight non-existent R11 and return areas as string
    areas = Area.parse('T1  R11')
    assert_equal areas.class.name, 'String'
    assert_equal 'T1R1 T1R2 T1R3 T1R4 T1R5 T1R6 *R11*'.split.sort, areas.split.sort
    # should get T1R1 among others
    areas = Area.parse('T1')
    assert areas.any? {|a| a.name = 'T1R1'}
    # should get T1R1 among others
    areas = Area.parse('R1')
    assert areas.any?   {|a| a.name == 'T1R1'}
    
    areas =  Area.parse("T2 T4")
    assert areas.all? {|x| x.class.name == 'Area'}
    assert areas.any? {|a| a.name == 'T2R1'} # T2R1
    assert areas.any? {|a| a.name == 'T4R2'}
    ar = Area.find(:first, :conditions => "name = 'T4R1'")
    assert areas.any? {|a| a.name == ar.name}
    
    areas = Area.parse('F1')
    assert areas.any? {|a| a.name == "F1R1"}
    
    areas = Area.parse('B20')
    assert areas.any? {|a| a.name == "B20R1"}
    	
    # B31 should not be in the fixture	
    areas  = Area.parse('B31')
    assert_equal areas.class.name, 'String'
    
    # should get empty array
    areas  = Area.parse("")
    assert_equal areas.class.name, 'Array'
    assert_equal 0, areas.size
    
    # should get array with one element
    areas = Area.parse('T1R1')
    assert areas.all? {|x| x.class.name=='Area'}
    assert_equal "T1R1", areas[0].name
    assert_equal 1, areas.size
    
    # T1R8 should not be in the fixture
    areas  = Area.parse('T1R8')
    assert_equal areas.class.name, 'String'
    
    areas  = Area.parse('REPT4E1')
    assert areas.any?  {|a| a.name =='REPT4E1R1'}
    
    areas  = Area.parse('iF9')
    assert areas.any? {|a| a.name  == 'iF9R1' }
  end
  
  def test_area_unparse
    areas  = Area.find_all_by_treatment_and_study_id('1','1')
    area_string = Area.unparse(areas)
    assert_equal 'T1', area_string
    
    areas = Area.parse('T1 T2')
    area_string = Area.unparse(areas)
    areas = area_string.split(' ').collect {|x|  x.to_sym }
    assert_equal  [:T1, :T2].to_set, areas.to_set
  end
  
  def test_comparison
  	# studies
		area1 = Area.new(:name => 'a1', :treatment_id => 1, :replicate => 1, :study_id => 1)
		area2 = Area.new(:name => 'a2', :treatment_id => 1, :replicate => 1, :study_id => 2)
		assert_equal 0, area1 <=> area1
		assert_equal -1, area1 <=> area2
		assert_equal 1, area2 <=> area1
		
		# treatments
		area1 = Area.new(:name => 'a1', :treatment_id => 1, :replicate => 1, :study_id => 1)
		area2 = Area.new(:name => 'a2', :treatment_id => 2, :replicate => 1, :study_id => 1)
		assert_equal 0, area1 <=> area1
		assert_equal -1, area1 <=> area2
		assert_equal 1, area2 <=> area1
		
		# replicates
		area1 = Area.new(:name => 'a1', :treatment_id => 1, :replicate => 1, :study_id => 1)
		area2 = Area.new(:name => 'a2', :treatment_id => 1, :replicate => 2, :study_id => 1)
		assert_equal 0, area1 <=> area1
		assert_equal -1, area1 <=> area2
		assert_equal 1,area2 <=> area1
		
  	# nil replicate
		area1 = Area.new(:name => 'a1', :treatment_id => 1, :replicate => 1, :study_id => nil)
		area2 = Area.new(:name => 'a2', :treatment_id => 2, :replicate => 1, :study_id => nil)
		assert_equal 0, area1 <=> area1
		assert_equal -1, area1 <=> area2
		assert_equal 1,area2 <=> area1
		
		# this generates no-method error - nil object
		# area1 = Area.new(:name => 'a1', :treatment => 1, :replicate => 1, :study_id => nil)
		# area2 = Area.new(:name => 'a2', :treatment => 1, :replicate => 1, :study_id => 1)
		# assert_equal area1 <=> area1, 0
		# assert_equal area1 <=> area2, -1
		# assert_equal area2 <=> area1, 1
	end
    
  def test_area_not_full_rep_unparse
    parse_reverse('T1R1')
    
    areas =  Area.parse('T1R1 T2')
    area_string  = Area.unparse(areas)
    areas = area_string.split(' ').collect {|x| x.to_sym}
    assert_equal [:T1R1,:T2].to_set, areas.to_set
  end
  
  def test_area_parse_to_study
    study = Study.find(:first)
    area_string = Area.unparse(study.areas)
    assert_equal 'MAIN', area_string
  end
  
  def test_area_parse_to_many_studies
  
    areas = Area.find_all_by_study_id(1)
    area_string = Area.unparse(areas)
    assert_equal "MAIN", area_string
    
    study = Study.find(2)
    areas = study.areas
    area_string = Area.unparse(areas)
    assert_equal "Biodiversity", area_string
  end
  
  def test_area_unparse_to_treatments  
    parse_reverse('T1')
    parse_reverse('B1')
  end
  
  def test_area_unparse_many_strings
  	test_strings = 
  	[ "T1 B1",
  		"B1 T1",
  		"T1 T2R1",
  		"B1 B2R1",
  		"T1R1 T1R2 T1R3",
  		"B1R1 B1R2 B1R3",
  		# "F1", 
  		# "iF1", 
  		# "REPT1",
  		"T1" # tidy end for comma list
  	]
  	test_strings.each do |s|
  	  parse_reverse(s)
	  end
  end
  
  def test_area_unparse_case_sensitive
  	parse_reverse("t1")
  end
  
  def test_area_unparse_sequence_sensitive
  	parse_reverse("B2R1 B1")
  end 
  
  def test_area_unparse_to_study_name 
   	areas = Area.parse("T1 T2 T3 T4 T5 T6 T7 T8")
    area_string = Area.unparse(areas)
    assert_equal "MAIN", area_string
    
  	areas = Area.parse("B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21")
    area_string = Area.unparse(areas)
    assert_equal "Biodiversity", area_string
  end
  
  def test_no_area_unparse
    assert_equal "", Area.unparse()
  end
  
  def test_area_not_in_study
    parse_reverse('ECB')
  end
  
  def test_glrbc_parse
    parse_reverse('G1R4')
    parse_reverse('G2')
    parse_reverse('G10')
  end
  
private

  def parse_reverse(test_string)
  	areas = Area.parse(test_string)
  	unparsed_area_string = Area.unparse(areas)
  	assert_equal test_string.upcase.split.sort.join(' '), unparsed_area_string.split.sort.join(' ')
  end
 
end
