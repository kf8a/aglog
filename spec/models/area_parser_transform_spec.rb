require 'spec_helper'

describe 'AreaParserTransform' do
  let(:parser)    { AreaParser.new          }
  let(:trans)     { AreaParserTransform.new }

  describe 'simple plot' do
    before(:each) do
      @result = trans.apply(parser.parse('T1R1'))[0]
    end

    it 'should transform the :treatment to an integer'

    it 'should transform the :replicate to an integer'
  end

  describe 'range' do
    before(:each) do
      parsed = parser.parse('T1-4')
      @result = trans.apply(parsed)
      p parsed
      p @result
    end
    it 'should transform treatment and treatment_end to a range' do
      assert_equal 'test', @result
    end
    
  end
end
