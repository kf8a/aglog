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
    assert_equal '1', result[:plot][:treatment]
    assert_equal '1', result[:plot][:replicate]
  end

  it 'should parse T3' do
    result = @parser.parse('T3')[0]
    assert_equal 'T', result[:study]
    assert_equal '3', result[:plot_range][:treatment]
  end

  it 'should parse T1-T3 to all of treatment 1 through 3 in study main' do
    result = @parser.parse('T1-3')[0]
    assert_equal 'T', result[:study]
    assert_equal '1', result[:plot_range][:treatment]
    assert_equal '3', result[:plot_range][:treatment_end]
  end

  it 'should parse G1R1' do
    result = @parser.parse('G1R1')[0]
    assert_equal "G", result[:study]
    assert_equal '1', result[:plot][:treatment]
    assert_equal '1', result[:plot][:replicate]
  end

  it 'should parse G' do
    result = @parser.parse('G')[0]
    assert_equal 'G', result[:whole_study]
  end

  it 'should parse G*R1' do
    result = @parser.parse('G*R1')[0]
    assert_equal 'G', result[:study]
    assert_equal '1', result[:rep_range][:replicate]
  end

  it 'should parse multiple plots with spaces between' do
    results = @parser.parse('T1R1 G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:plot][:treatment]
    assert_equal '1', results[0][:plot][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:plot][:treatment]
    assert_equal '4', results[1][:plot][:replicate]
  end
  
  it 'should parse mulitple areas with commas between' do
    results = @parser.parse('T1R1,G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:plot][:treatment]
    assert_equal '1', results[0][:plot][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:plot][:treatment]
    assert_equal '4', results[1][:plot][:replicate]
  end

  it 'should parse mulitple areas with comma and space between' do
    results = @parser.parse('T1R1, G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:plot][:treatment]
    assert_equal '1', results[0][:plot][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:plot][:treatment]
    assert_equal '4', results[1][:plot][:replicate]
  end

  it 'should parse mulitple areas with space and comma between' do
    results = @parser.parse('T1R1 ,G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:plot][:treatment]
    assert_equal '1', results[0][:plot][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:plot][:treatment]
    assert_equal '4', results[1][:plot][:replicate]
  end

  it 'should parse mulitple areas with space and comma and space between' do
    results = @parser.parse('T1R1 , G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:plot][:treatment]
    assert_equal '1', results[0][:plot][:replicate]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:plot][:treatment]
    assert_equal '4', results[1][:plot][:replicate]
  end

  it 'should parse T1-4 G2R4' do
    results = @parser.parse('T1-4 G2R4')
    assert_equal 'T', results[0][:study]
    assert_equal '1', results[0][:plot_range][:treatment]
    assert_equal '4', results[0][:plot_range][:treatment_end]
    assert_nil        results[0][:plot]
    assert_equal 'G', results[1][:study]
    assert_equal '2', results[1][:plot][:treatment]
    assert_equal '4', results[1][:plot][:replicate]
  end
  
  it 'should not parse T1-3R3' 
end
