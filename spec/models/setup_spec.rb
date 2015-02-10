require 'rails_helper'

describe Setup do
  it "should allow a setup to be created with valid equipment" do
    equipment = find_or_factory(:equipment)
    setup = Setup.new(:equipment_id => equipment.id)
    setup.should be_valid
  end

  it "should not allow a setup to be created with invalid equipment" do
    ssetup = Setup.new(:equipment_id => 9999) # invalid equipment
    ssetup.should_not be_valid
  end
end

