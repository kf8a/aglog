require 'spec_helper'

describe 'AreaParserTransform' do
  let(:parser)    { AreaParser.new          }
  let(:trans)     { AreaParserTransform.new }

  describe 'simple plot' do
    before(:each) do
      @result = trans.apply(parser.parse('T1R1'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal ['areas.name = ?', 'T1R1'], @result[:where]
    end
  end
   
  describe 'an irregular plot'do
    before(:each) do
      @result = trans.apply(parser.parse('CE101'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'CE', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal ['areas.name = ?','CE101'], @result[:where]
    end
  end

  describe 'multi rep range' do
    before(:each) do
      @result = trans.apply(parser.parse('T1'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal ['treatments.treatment_number in (?)', 1], @result[:where]
    end
  end

  describe 'multi treatment range' do
    before(:each) do
      @result = trans.apply(parser.parse('T1-4'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal ['treatments.treatment_number in (?)', 1..4] , @result[:where]
    end
  end

  describe 'replicate wildcard' do
    before(:each) do
      @result = trans.apply(parser.parse('T*R1'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal ['replicate = ?', 1], @result[:where]
    end
  end

  describe 'whole studies' do
    before(:each) do
      @result = trans.apply(parser.parse('T'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
    end
  end
end
