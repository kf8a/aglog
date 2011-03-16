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
      assert_equal 'T1R1', @result[:name]
    end
  end

  describe 'multi rep range' do
    before(:each) do
      @result = trans.apply(parser.parse('T1'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal 1, @result[:treatment_number]
    end
  end

  describe 'multi treatment range' do
    before(:each) do
      @result = trans.apply(parser.parse('T1-4'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal 1..4, @result[:treatment_number]
    end
  end

  describe 'replicate wildcard' do
    before(:each) do
      @result = trans.apply(parser.parse('T*R1'))[0]
    end

    it 'should transform it into a hash for a where clause' do
      assert_equal 'T', @result[:study]
      assert_kind_of String, @result[:study]
      assert_equal 1, @result[:replicate]
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
