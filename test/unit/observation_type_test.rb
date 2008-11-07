require File.dirname(__FILE__) + '/../test_helper'

class ObservationTypeTest < Test::Unit::TestCase
  fixtures :observation_types

  def test_uniqueness
    num_of_items =  ObservationType.count()
    test_name = 'Weed control'
    a  = ObservationType.new(:name => test_name) # is in fixture already
    assert !a.save
    assert !a.errors.empty?
    
    a  = ObservationType.new(:name => test_name.upcase) # case insensitive
    assert !a.save
    assert !a.errors.empty?
    
    a = ObservationType.new(:name => 'A New ObservationType') # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_items + 1, ObservationType.count
  end
  
end
