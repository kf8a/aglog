require 'spec_helper'

# T1R1 => T1R1
# T*R1 => [T1R1, T2R1, T3R1, T4R4, T5R1, T6R1, T7R1, T8R1]
# T1R* || T1 => [T1R1, T1R2, T1R3, T1R4, T1R5, T1R6]
# T1-T3 => [All of T1 to T4]
# G1 - G12 => All of G1 to G12]

describe 'AreaParser' do
  before(:all) do
    @parser = AreaParser.new
  end

  after(:all) do
    @parser = nil
  end

  it 'should parse T1R1 to treatment 1 and rep 1' do
    result =  @parser.parse("T1R1")[0]
    assert_equal "T", result[:study]
    assert_equal '1', result[:name][:treatment]
    assert_equal '1', result[:name][:replicate]
  end

  it 'should parse CE102' do
    assert @parser.irregular_plot.parse('123')
    result =  @parser.parse("CE102")[0]
    assert_equal "CE", result[:study]
    assert_equal '102', result[:name]
  end

  it 'should parse T3' do
    result = @parser.parse('T3')[0]
    assert_equal 'T', result[:study]
    assert_equal '3', result[:treatment_number][:treatment]
  end

  it 'should parse T1-T3 to all of treatment 1 through 3 in study main' do
    result = @parser.parse('T1-3')[0]
    assert_equal 'T', result[:study]
    assert_equal '1', result[:treatment_number][:treatment]
    assert_equal '3', result[:treatment_number][:treatment_end]
  end

  it 'should parse G1R1' do
    result = @parser.parse('G1R1')[0]
    assert_equal "G", result[:study]
    assert_equal '1', result[:name][:treatment]
    assert_equal '1', result[:name][:replicate]
  end

  it 'should parse G' do
    result = @parser.parse('G')[0]
    assert_equal 'G', result[:study]
  end

  it 'should parse G*R1' do
    result = @parser.parse('G*R1')[0]
    assert_equal 'G', result[:study]
    assert_equal '1', result[:replicate_number][:replicate]
  end

  it 'should parse multiple names with spaces between' do
    results = @parser.parse('T1R1 G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:name][:treatment]
    assert_equal '1', results[0][:name][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:name][:treatment]
    assert_equal '4', results[1][:name][:replicate]
  end
  
  it 'should parse mulitple areas with commas between' do
    results = @parser.parse('T1R1,G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:name][:treatment]
    assert_equal '1', results[0][:name][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:name][:treatment]
    assert_equal '4', results[1][:name][:replicate]
  end

  it 'should parse mulitple areas with comma and space between' do
    results = @parser.parse('T1R1, G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:name][:treatment]
    assert_equal '1', results[0][:name][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:name][:treatment]
    assert_equal '4', results[1][:name][:replicate]
  end

  it 'should parse mulitple areas with space and comma between' do
    results = @parser.parse('T1R1 ,G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:name][:treatment]
    assert_equal '1', results[0][:name][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:name][:treatment]
    assert_equal '4', results[1][:name][:replicate]
  end

  it 'should parse mulitple areas with space and comma and space between' do
    results = @parser.parse('T1R1 , G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:name][:treatment]
    assert_equal '1', results[0][:name][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:name][:treatment]
    assert_equal '4', results[1][:name][:replicate]
  end

  it 'should parse T1-4 G2R4' do
    results = @parser.parse('T1-4 G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:treatment_number][:treatment]
    assert_equal '4', results[0][:treatment_number][:treatment_end]
    assert_nil        results[0][:name]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:name][:treatment]
    assert_equal '4', results[1][:name][:replicate]
  end
  
  it 'should not parse T1-3R3' 

end