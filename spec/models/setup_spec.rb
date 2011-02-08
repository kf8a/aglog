require 'spec_helper'

describe Setup do
  it "should allow a setup to be created with valid equipment" do
    equipment = find_or_factory(:equipment)
    old_count =  Setup.count
    s =  Setup.new(:equipment_id => equipment.id)
    assert s.save
    assert_equal old_count+1, Setup.count
  end

  it "should not allow a setup to be created with invalid equipment" do
    old_count =  Setup.count
    s = Setup.new(:equipment_id => 9999) # invalid equipment
    assert !s.save
    assert_equal old_count, Setup.count
  end
end

