require 'rails_helper'

describe Setup do
  it "allows a setup to be created with valid equipment" do
    equipment = find_or_factory(:equipment)
    setup = Setup.new(:equipment_id => equipment.id)
    expect(setup).to be_valid
  end

  it "does not allow a setup to be created with invalid equipment" do
    ssetup = Setup.new(:equipment_id => 9999) # invalid equipment
    expect(ssetup).to_not be_valid
  end
end

