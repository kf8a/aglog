require 'spec_helper'

describe 'AreaParserTransform' do
  let(:parser)    { AreaParser.new          }
  let(:trans)     { AreaParserTransform.new }

  describe 'simple plot' do
    before(:each) do
      @result = trans.apply(parser.parse('T1R1'))[0]
    end

    it 'should transform it into a where clause' do
      assert_equal %q{where(:study => "T", :plot => "T1R1")}, @result
    end

  end

  describe 'multi rep range' do
    before(:each) do
      @result = trans.apply(parser.parse('T1'))[0]
    end

    it 'should transform it into a where clause' do
      assert_equal %q{where(:study => "T", :treatment_number => 1)}, @result
    end
  end

  describe 'multi treatment range' do
    before(:each) do
      @result = trans.apply(parser.parse('T1-4'))[0]
    end

    it 'should transform it into a where clause' do
      assert_equal %q{where(:study => "T", :treatment_number => 1..4)}, @result
    end
  end

  describe 'replicate wildcard' do
  end
end
