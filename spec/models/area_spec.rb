require 'rails_helper'

def non_existent_study_id
  id = 1
  while Study.exists?(id)
    id += 1
  end

  id
end

describe Area do
  it {is_expected.to belong_to :company}

  describe "requires a unique name within a company: " do
    context "An area exists with a name. " do
      before(:each) do
        find_or_factory(:area, :name => 'T1R1', :company_id => 1)
      end

      describe "an area with the same name" do

        it 'does not allow a second area witht the smae name to be created' do
          area = Area.new(:name => 'T1R1')
          area.company_id = 1
          expect(area).to_not be_valid
        end

        it 'is case insensitive' do
          area = Area.new(:name => 't1r1')
          area.company_id = 1
          expect(area).to_not be_valid
        end

        it 'allows it in a different company' do
          area = Area.new(name: 'T1R1', company_id: 3000)
          expect(area).to be_valid
        end
      end


      describe "an area with a different name" do
        before(:each) do
          expect(Area.exists?(:name => 'T1R11')).to eq false
        end

        subject { Area.new(:name => 'T1R11') }
        it { is_expected.to be_valid }
      end

    end
  end

  describe 'finding Areas within a company' do
  end

  describe 'expanding and coalesing Areas' do
    context 'a plot with children' do
      before(:each) do
        @ancestor = find_or_factory(:area, :name=>'Test1')
        @child1 = find_or_factory(:area, :name=>'Test1R1')
        @child2 = find_or_factory(:area, :name=>'Test1R2')
        @child3 = find_or_factory(:area, :name=>'Test2R1')
        @child1.move_to_child_of(@ancestor)
        @child2.move_to_child_of(@ancestor)
        @ancestor.save
      end
      it 'includes child1' do
        expect(@ancestor.descendants).to include @child1
      end
      it 'includes child2' do
        expect(@ancestor.descendants).to include @child2
      end
      it 'does not include child3' do
        expect(@ancestor.descendants).to_not include @child3
      end

      context 'coalesing area' do

        it 'returns the ancestor'  do
          expect(Area.coalese([@child1, @child2])).to eq [@ancestor]
        end
        it 'returns the child for one child' do
          expect(Area.coalese([@child1])).to eq [@child1]
        end
        it 'returns the ancestor when given the ancestor' do
          expect(Area.coalese([@ancestor])).to eq [@ancestor]
        end
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
      it { is_expected.to be_valid }
    end

    describe "an area with an invalid study id" do
      subject { Area.new(:study_id => @non_existent_study, :name => 'invalid_study') }
      it { is_expected.to_not be_valid }
    end

    describe "an area with no study id" do
      subject { Area.new(:study_id => nil, :name => 'area_without_study') }
      it { is_expected.to be_valid }
    end
  end

  describe "requires the study of the treatment if it has a treatment: " do
    before(:each) do
      @study = find_or_factory(:study)
      @another_study = FactoryBot.create(:study, name: 'another_study')
      @treatment = find_or_factory(:treatment, study_id: @study.id)
    end

    describe 'an area with a treatment and a consistent study' do
      subject { Area.new(study_id: @study.id, treatment_id: @treatment.id,
                         name: 'consistent_area') }
      it { is_expected.to be_valid }
    end

    describe 'an area with a treatment and no study' do
      subject { Area.new(study_id: nil, treatment_id: @treatment.id, name: 'no_study_area') }
      it { is_expected.to be_valid }
    end

    # describe "an area with a treatment and an inconsistent study" do
    #   subject { Area.new(study_id: @another_study.id, treatment_id: @treatment.id, name: 'inconsistent_area')}
    #   it { is_expected.to_not be_valid }
    # end
  end

  describe 'self.parse should parse strings into areas: ' do
    it 'highlights non-existent areas and return string' do
      areas = Area.parse('T1  R11')
      expect(areas).to be_a String
      assert_equal 'T1 *R11*'.split.sort, areas.split.sort
    end

    it "returns area T1R1 (among others) when given 'T1' to parse" do
      areas = Area.parse('T1')
      assert(areas.any? { |a| a.name == 'T1R1' })
    end

    # it "correctly parses 'T2 T4'" do
    #   areas = Area.parse("T2 T4")
    #   assert areas.all? {|x| x.class.name == 'Area'}
    #   assert areas.any? {|a| a.name == 'T2R1'} # T2R1
    #   # assert areas.any? {|a| a.name == 'T4R2'}
    #   ar = Area.where(:name => 'T4R1').first
    #   assert areas.include?(ar)
    # end

    it "correctly parses 'F1'" do
      areas = Area.parse('F1')
      assert areas.any? {|a| a.name == "F1R1"}
    end

    it "correctly parses 'B20'" do
      areas = Area.parse('B20')
      assert areas.any? { |a| a.name == "B20R1" }
    end

    it "correctly parses 'B31' as a String (there is no B31 area)" do
      area = Area.parse('B31')
      expect(area).to eq '*B31*'
    end

    it "returns an empty array when given '' to parse" do
      areas = Area.parse('')
      expect(areas).to be_a Array
      expect(areas.size).to eq 0
    end

    it 'returns an array with one element when given a whole area name to parse' do
      areas = Area.parse('T1R1')
      assert areas.all? {|x| x.class.name =='Area'}
      assert_equal 'T1R1', areas[0].name
      assert_equal 1, areas.size
    end

    it "correctly parses 'T1R8' as a String (there is no T1R8 area)" do
      areas = Area.parse('T1R8')
      expect(areas).to be_a String
    end

    it "correctly parses 'iF9'" do
      areas = Area.parse('iF9')
      assert areas.any? {|a| a.name  == 'iF9R1' }
    end

    it 'correctly parses Fertility Gradient areas' do
      areas = Area.parse('F')
      real_areas = Area.where(study_id: 3)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('F4')
      real_areas = Treatment.find_by(name: 'F4').areas
      assert_equal [], (areas - real_areas)
    end

    it 'correctly parses Irrigated Fertility Gradient areas' do
      areas = Area.parse('iF')
      study = Study.where(name: 'IF').first
      real_areas = Area.where(study_id: study.id)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('iF7')
      real_areas = Treatment.find_by(name: 'iF7').areas.to_a.flatten
      assert_equal [], (areas - real_areas)
    end

    it 'correctly parses CE areas' do
      areas = Area.parse('CE')
      study = Study.where(name: 'CE').first
      real_areas = Area.where(study_id: study.id)
      assert_equal [], (areas - real_areas)

      areas = Area.parse('CE1')
      real_areas = Treatment.where(name: 'CE1').first.areas
      assert_equal [], (areas - real_areas)
    end

    it 'correctly parses GLBRC areas' do
      areas = Area.parse('G1')
      real_areas = Area.where(study_id: 6)
      assert_equal [], (areas - real_areas)
    end

    it 'correctly parses LYSIMETER field' do
      areas = Area.parse('LYSIMETER_FIELD')
      real_areas = Area.where(study_id: 9)
      assert_kind_of Array, areas
      assert_equal [], (areas - real_areas)
    end

    describe 'areas with the same name from different company' do
      before(:each) do
        @area = Area.where(name: 'T1R1').first
        @area.company_id = 1
        @area.save
      end

      it 'parses the area associated with the current users company' do
        assert_equal @area, Area.parse('T1R1', company: 1)[0]
      end

      it 'does not parse any other areas' do
        expect(Area.parse('T1R1', company: 2)).to eq '*T1R1*'
      end
    end
  end

  describe 'self.unparse should consolidate a list of areas into a string: ' do
    it "returns 'T1' when given an array of all the T1 areas" do
      areas = Treatment.where(name: 'T1').first.areas.to_a.flatten
      area_string = Area.unparse(areas)
      assert_equal 'T1', area_string
    end

    it 'correctly unparses the T1 and T2 areas' do
      parse_reverse('T1 T2')
    end

    it "correctly unparses 'T1R1 T2'" do
      parse_reverse('T1R1 T2')
    end

    it "unparses an array of all of a study's areas, returning the study name" do
      study = Study.where(name: 'T').first
      area_string = Area.unparse(study.areas)
      assert_equal 'T', area_string

      study = Study.where(name: 'B').first
      areas = study.areas
      area_string = Area.unparse(areas)
      assert_equal 'B', area_string

      areas = Area.parse('T1 T2 T3 T4 T5 T6 T7 T8')
      area_string = Area.unparse(areas)
      assert_equal 'T', area_string

      areas = Area.parse('B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21')
      area_string = Area.unparse(areas)
      assert_equal 'B', area_string
    end

    it 'unparses treatment areas to the treatment name' do
      parse_reverse('T1')
      parse_reverse('B1')
    end

    it 'correctly unparses various other areas' do
      test_strings =
        ['T1 B1',
         'B1 T1',
         'T1 T2R1',
         'B1 B2R1',
         'T1R1 T1R2 T1R3',
         'B1R1 B1R2 B1R3',
         'F1',
         'iF1',
         # 'REPT1',
         'T1']

      test_strings.each do |s|
        parse_reverse(s)
      end
    end

    it 'correctly parse/unparses in the right order' do
      parse_reverse('B2R1 B1')
    end

    it "unparses nothing to ''" do
      expect(Area.unparse).to match ''
    end

    it 'correctly parse/unparses an area not in study' do
      # parse_reverse('ECB')
    end

    it "should correctly parse/unparse 'T'" do
      parse_reverse('T')
    end

    it 'should correctly parse/unparse GLBRC areas' do
      parse_reverse('G1R4')
      parse_reverse('G2')
      parse_reverse('G10')
      parse_reverse('G')
    end

    it 'should correctly parse/unparse CES areas' do
      parse_reverse('CE')
      parse_reverse('CE1')
      parse_reverse('CE101')
    end

    it 'should correctly parse/unparse WICST areas' do
      parse_reverse('ldpR1')
      parse_reverse('ldpR2')
      parse_reverse('ldpR3')
      parse_reverse('hdpR1')
      parse_reverse('hdpR2')
      parse_reverse('hdpR3')
      parse_reverse('sgR1')
      parse_reverse('sgR2')
      parse_reverse('sgR3')
    end

    it 'should return and correctly mark problematic areas' do
      assert_equal '*G34*', Area.parse('G34')
      assert_equal 'G2R1 *G34*', Area.parse('G2R1, G34')
      assert_equal 'G2R1 *G34-*', Area.parse('G2R1, G34-')
      assert_equal 'G2R1 *G34**', Area.parse('G2R1, G34*')
    end
  end

  private

  def parse_reverse(test_string)
    areas = Area.parse(test_string)
    expect(areas).to be_a Array
    expect(areas).to_not be_empty
    unparsed_area_string = Area.unparse(areas)
    assert_equal test_string.upcase.split.sort.join(' '), unparsed_area_string.upcase.split.sort.join(' ')
  end

  def find_by_study_and_treatment_number(study, treatment_number)
    treatments = Treatment.where(study_id: study,
                                 treatment_number: treatment_number)
    treatments.collect(&:areas).flatten
  end
end
