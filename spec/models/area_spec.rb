require 'spec_helper'

def non_existent_study_id
  id = 1
  while Study.exists?(id)
    id += 1
  end

  id
end

describe Area do
  it {should belong_to :company}

  describe "requires a unique name within a company: " do
    context "An area exists with a name. " do
      before(:each) do
        find_or_factory(:area, :name => 'T1R1', :company_id => 1)
      end

      describe "an area with the same name" do

        it 'should not allow a second area witht the smae name to be created' do
          a = Area.new(:name => 'T1R1')
          a.company_id = 1
          assert !a.valid?
        end

        it 'should be case insensitive' do
          a = Area.new(:name => 't1r1')
          a.company_id = 1
          assert !a.valid?
        end
      end

      describe "an area with a different name" do
        before(:each) do
          Area.exists?(:name => 'T1R11').should be_false
        end

        subject { Area.new(:name => 'T1R11') }
        it { should be_valid }
      end
    end
  end

  describe "requires valid study if any: " do
    before(:each) do
      @existent_study = find_or_factory(:study)
      @non_existent_study = non_existent_study_id
      assert !Study.exists?(@non_existent_study)
    end

    describe "an area with a valid study (and name)" do
      subject { Area.new(:study_id => @existent_study.id, :name => 'valid_study') }
      it { should be_valid }
    end

    describe "an area with an invalid study id" do
      subject { Area.new(:study_id => @non_existent_study, :name => 'invalid_study') }
      it { should_not be_valid }
    end

    describe "an area with no study id" do
      subject { Area.new(:study_id => nil, :name => 'area_without_study') }
      it { should be_valid }
    end
  end

  describe "requires the study of the treatment if it has a treatment: " do
    before(:each) do
      @study = find_or_factory(:study)
      @another_study = Factory.create(:study, :name => 'another_study')
      @treatment = find_or_factory(:treatment, :study_id => @study.id)
    end

    describe "an area with a treatment and a consistent study" do
      subject { Area.new(:study_id => @study.id, :treatment_id => @treatment.id, :name => 'consistent_area') }
      it { should be_valid }
    end

    describe "an area with a treatment and no study" do
      subject { Area.new(:study_id => nil, :treatment_id => @treatment.id, :name => 'no_study_area') }
      it { should_not be_valid }
    end

    describe "an area with a treatment and an inconsistent study" do
      subject { Area.new(:study_id => @another_study.id, :treatment_id => @treatment.id, :name => 'inconsistent_area')}
      it { should_not be_valid }
    end
  end

  describe "self.parse should parse strings into areas: " do
    it "should highlight non-existent areas and return string" do
      areas = Area.parse('T1  R11')
      areas.should be_a String
      assert_equal 'T1 *R11*'.split.sort, areas.split.sort
    end

    it 'should return T1R1 when given T1R1 to parse'do
      assert_equal 'T1R1', Area.parse('T1R1')[0].name
    end

    it "should return area T1R1 (among others) when given 'T1' to parse" do
      areas = Area.parse('T1')
      assert areas.any? {|a| a.name = 'T1R1'}
    end

    it "should return area T1R1 (among others) when given 'T*R1' to parse" do
      areas = Area.parse('T*R1')
      assert areas.any? {|a| a.name = 'T1R1'}
    end

    it "should correctly parse 'T2 T4'" do
      areas = Area.parse("T2 T4")
      assert areas.all? {|x| x.class.name == 'Area'}
      assert areas.any? {|a| a.name == 'T2R1'} # T2R1
      assert areas.any? {|a| a.name == 'T4R2'}
      ar = Area.where(:name => 'T4R1').first
      assert areas.include?(ar)
    end

    it "should correctly parse 'F1'" do
      areas = Area.parse('F1')
      assert areas.any? {|a| a.name == "F1R1"}
    end

    it "should correctly parse 'B20'" do
      areas = Area.parse('B20')
      assert areas.any? { |a| a.name == "B20R1" }
    end

    it "should correctly parse 'B31' as a String (there is no B31 area)" do
      assert_equal '*B31*', Area.parse('B31')
    end

    it "should return an empty array when given '' to parse" do
      areas = Area.parse('')
      areas.should be_a Array
      areas.size.should equal 0
    end

    it "should get an array with one element when given a whole area name to parse" do
      areas = Area.parse('T1R1')
      assert areas.all? {|x| x.class.name =='Area'}
      assert_equal "T1R1", areas[0].name
      assert_equal 1, areas.size
    end

    it "should correctly parse 'T1R8' as a String (there is no T1R8 area)" do
      areas = Area.parse('T1R8')
      areas.should be_a String
    end

    it "should correctly parse 'iF9'" do
      areas = Area.parse('iF9')
      assert areas.any? {|a| a.name  == 'iF9R1' }
    end

    it "should correctly parse a treatment range ('T1-4')" do
      areas = Area.parse('T1-4')
      real_areas = ['T1','T2','T3','T4'].collect do |name|
        Treatment.find_by_name(name).areas
      end.flatten
#      real_areas = Area.find_all_by_study_id_and_treatment_number(1, 1..7)
      assert_equal [], (areas - real_areas)
    end

    it "should correctly parse Fertility Gradient areas" do
      areas = Area.parse('F')
      real_areas = Area.find_all_by_study_id(3)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('F4')
      real_areas = find_by_study_and_treatment_number(3, 4)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('F2-3')
      real_areas = find_by_study_and_treatment_number(3, 2..3)
      assert_equal [], (areas - real_areas)
    end

    it "should correctly parse Irrigated Fertility Gradient areas" do
      areas = Area.parse('iF')
      real_areas = Area.find_all_by_study_id(4)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('iF7')
      real_areas = find_by_study_and_treatment_number(4, 7)
      assert_equal [], (areas - real_areas)

      areas = Area.parse("iF1-4")
      real_areas = find_by_study_and_treatment_number(4, 1..4)
      assert_equal [], (areas - real_areas)
    end

    it 'should correctly parse CE areas' do
      areas = Area.parse('CE')
      real_areas = Area.find_all_by_study_id(7)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('CE1')
      real_areas = find_by_study_and_treatment_number(7,1)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('CE1-12')
      real_areas = find_by_study_and_treatment_number(7,1..12)
      assert_not_equal [], real_areas
      assert_not_equal [], areas
      assert_equal [], (areas - real_areas)
    end

    it 'should correctly parse GLBRC areas' do
      areas = Area.parse('G1')
      real_areas = Area.find_all_by_study_id(6)
      assert_equal [], (areas - real_areas)
    end

    it 'should correctly parse LYSIMETER field' do
      areas = Area.parse('LYSIMETER_FIELD')
      real_areas = Area.find_all_by_study_id(9)
      assert_kind_of Array, areas
      assert_equal [], (areas - real_areas)
    end

    describe 'areas with the same name from different company' do
      before(:each) do
        @area = Area.find_by_name('T1R1') 
        @area.company_id = 1
        @area.save
      end

      it 'should parse the area associated with the current users company' do
        assert_equal @area, Area.parse('T1R1', :company => 1)[0]
      end

      it 'should not parse any other areas' do
        assert_equal '*T1R1*', Area.parse('T1R1', :company => 2 )
      end
    end
  end

  describe "self.unparse should consolidate a list of areas into a string: " do
    it "should return 'T1' when given an array of all the T1 areas" do
      areas  = find_by_study_and_treatment_number('1','1') + find_by_study_and_treatment_number(1, 1)
      area_string = Area.unparse(areas)
      assert_equal 'T1', area_string
    end

    it "should correctly unparse the T1 and T2 areas" do
      parse_reverse('T1 T2')
    end

    it "should correctly unparse 'T1R1 T2'" do
      parse_reverse('T1R1 T2')
    end

    it "should unparse an array of all of a study's areas, returning the study name" do
      study = Study.where(:name => 'T').first
      area_string = Area.unparse(study.areas)
      assert_equal 'T', area_string

      study = Study.where(:name => 'B').first
      areas = study.areas
      area_string = Area.unparse(areas)
      assert_equal "B", area_string

      areas = Area.parse("T1 T2 T3 T4 T5 T6 T7 T8")
      area_string = Area.unparse(areas)
      assert_equal "T", area_string

      areas = Area.parse("B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21")
      area_string = Area.unparse(areas)
      assert_equal "B", area_string
    end

    it "should unparse treatment areas to the treatment name" do
      parse_reverse('T1')
      parse_reverse('B1')
    end

    it "should correctly unparse various other areas" do
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

    it "should correctly parse/unparse in the right order" do
      parse_reverse("B2R1 B1")
    end

    it "should unparse nothing to ''" do
      Area.unparse().should match ""
    end

    it "should correctly parse/unparse an area not in study" do
#      parse_reverse('ECB')
    end

    it "should correctly parse/unparse 'T'" do
      parse_reverse('T')
    end

    it "should correctly parse/unparse GLBRC areas" do
      parse_reverse('G1R4')
      parse_reverse('G2')
      parse_reverse('G10')
      parse_reverse('G')
    end

    it "should correctly parse/unparse CES areas" do
      parse_reverse('CE')
      parse_reverse('CE1')
      parse_reverse('CE101')
    end
  end

  context 'An area with a study' do
    before(:each) do
      @study = Factory.create(:study, :name => 'Name of Study')
    end

    subject { Factory.create(:area, :study_id => @study.id) }
    its(:study_name) { should match 'Name of Study' }
  end

  describe 'An area with no study' do
    subject { Factory.create(:area, :study_id => nil) }
    its(:study_name) { should be_nil }
  end

  private

  def parse_reverse(test_string)
  	areas = Area.parse(test_string)
    areas.should be_a Array
    areas.should_not be_empty
  	unparsed_area_string = Area.unparse(areas)
  	assert_equal test_string.upcase.split.sort.join(' '), unparsed_area_string.split.sort.join(' ')
  end
  
  def find_by_study_and_treatment_number(study, treatment_number)
    treatments = Treatment.where(:study_id => study, :treatment_number => treatment_number)
    treatments.collect{ |t| t.areas}.flatten
  end
end

