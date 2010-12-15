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

  context "A material exists that is liquid. " do
    setup do
      @material = Factory.create(:material, :liquid => true)
    end

    context "to_mass(amount)" do
      should "be the right number" do
        assert_equal 4000, @material.to_mass(4)
      end
    end
  end
  
end
