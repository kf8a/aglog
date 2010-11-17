require 'test_helper'

class EquipmentTest < ActiveSupport::TestCase
  fixtures :equipment

  def test_uniqueness
    num_of_equipments =  Equipment.count()
    a  = Equipment.new(:name => 'John Deere 2155 Tractor') # is in fixture already
    assert !a.save
    assert !a.errors.empty?
    
    a  = Equipment.new(:name => 'JOHN DEERE 2155 TRACTOR') # case insensitive
    assert !a.save
    assert !a.errors.empty?
    
    a = Equipment.new(:name => 'A New Equipment') # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_equipments + 1, Equipment.count
  end
  
end
