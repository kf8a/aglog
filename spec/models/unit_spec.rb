require 'spec_helper'

describe Unit do
  it "should require unique name" do
    num_of_items =  Unit.count()
    test_name = 'ounce'
    a  = Unit.new(:name => test_name) # is in fixture already
    assert !a.save
    assert !a.errors.empty?

    a  = Unit.new(:name => test_name.upcase) # case insensitive
    assert !a.save
    assert !a.errors.empty?

    a = Unit.new(:name => 'A New Unit') # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_items + 1, Unit.count
  end
end

