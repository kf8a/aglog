require 'test_helper'

class MaterialTest < ActiveSupport::TestCase
  
  def test_uniqueness
    num_of_items =  Material.count()
    test_name = 'seed corn'
    a  = Material.new(:name => test_name) # is in fixture already
    assert !a.save
    assert !a.errors.empty?
    
    a  = Material.new(:name => test_name.upcase) # case insensitive
    assert !a.save
    assert !a.errors.empty?
    
    a = Material.new(:name => 'A New Material') # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_items + 1, Material.count
  end
  
end
