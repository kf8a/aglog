require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  
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
  	a = Area.new(:study_id => 1, :name => "something")
  	assert a.save
  	# area with invalid study
  	a = Area.new(:study_id => 99, :name => "something")
  	assert !a.save
  	# area without study is OK
  	a = Area.new(:name => 'area_without_study')
  	assert a.save  	
	end
	
	def test_treatment_requires_study
		a = Area.new(:study_id => 1, :treatment_id => 99, :name => "something")
		assert a.save
		a = Area.new(:treatment_id => 1, :name => "Something")
		assert !a.save
	end
  
  def test_parse
  	# should highlight non-existent R11 and return areas as string
    areas = Area.parse('T1  R11')
    assert_equal 'String', areas.class.name
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
    areas  = Area.find_all_by_treatment_number_and_study_id('1','1') + Area.find_all_by_treatment_id_and_study_id(1, 1)
    area_string = Area.unparse(areas)
    assert_equal 'T1', area_string
    
    areas = Area.parse('T1 T2')
    area_string = Area.unparse(areas)
    areas = area_string.split(' ').collect {|x|  x.to_sym }
    assert_equal  [:T1, :T2].to_set, areas.to_set
  end
  
  def test_area_not_full_rep_unparse
    parse_reverse('T1R1')
    parse_reverse('T2')
    
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

  def test_main
    parse_reverse('MAIN')
  end

  def test_t_range
    areas = Area.parse('t1-7')
    real_areas = Area.find_all_by_study_id_and_treatment_number(1, 1..7)
    assert_equal [], (areas - real_areas)
  end

  def test_t_not_r_parse
    areas = Area.parse('t2!r1')
    real_areas = Area.find_all_by_study_id_and_treatment_number_and_replicate(1, 2, 2..8)
    assert_equal [], (areas - real_areas)
  end

  def test_r_not_t_parse
    areas = Area.parse('r2!T1')
    real_areas = Area.find_all_by_study_id_and_replicate_and_treatment_number(1, 2, 2..8)
    assert_equal [], (areas - real_areas)
  end

  def test_f_parse
    areas = Area.parse('Fertility_Gradient')
    real_areas = Area.find_all_by_study_id(3)
    assert_equal [], (areas - real_areas)

    areas = Area.parse('F4')
    real_areas = Area.find_all_by_study_id_and_treatment_number(3, 4)
    assert_equal [], (areas - real_areas)

    areas = Area.parse('F2-3')
    real_areas = Area.find_all_by_study_id_and_treatment_number(3, 2..3)
    assert_equal [], (areas - real_areas)
  end

  def test_if_parse
    areas = Area.parse('Irrigated_Fertility_Gradient')
    real_areas = Area.find_all_by_study_id(4)
    assert_equal [], (areas - real_areas)

    areas = Area.parse('iF7')
    real_areas = Area.find_all_by_study_id_and_treatment_number(4, 7)
    assert_equal [], (areas - real_areas)

    areas = Area.parse("iF1-4")
    real_areas = Area.find_all_by_study_id_and_treatment_number(4, 1..4)
    assert_equal [], (areas - real_areas)
  end
  
  def test_glrbc_parse
    parse_reverse('G1R4')
    parse_reverse('G2')
    parse_reverse('G10')
    parse_reverse('GLBRC')
  end

  def test_ces_parse
    parse_reverse('CES')
    parse_reverse('CE1')
    parse_reverse('ce13')
  end

  context 'An area with a study' do
    setup do
      @study = Factory.create(:study, :name => 'Testable Name')
      @area = Factory.create(:area, :study_id => @study.id)
    end

    should 'return the name of the study on study_name' do
      assert_equal @study.name, @area.study_name
    end
  end

  context 'An area with no study' do
    setup do
      @area = Factory.create(:area, :study_id => nil)
    end

    should 'return nil for study_name' do
      assert_equal nil, @area.study_name
    end
  end
  
private

  def parse_reverse(test_string)
  	areas = Area.parse(test_string)
  	unparsed_area_string = Area.unparse(areas)
  	assert_equal test_string.upcase.split.sort.join(' '), unparsed_area_string.split.sort.join(' ')
  end
 
end
