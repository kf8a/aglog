require 'test_helper'

class SetupTest < ActiveSupport::TestCase

  def test_should_create_setup
    old_count =  Setup.count
    s =  Setup.new(:equipment_id => 12)
    assert s.save
    assert_equal old_count+1, Setup.count
  end
  
  def test_should_not_create_setup 
    old_count =  Setup.count
    s = Setup.new(:equipment_id => 9999) # invalid equipment
    assert !s.save
    assert_equal old_count, Setup.count
  end
  
end
