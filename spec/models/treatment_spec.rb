require 'spec_helper'

describe Treatment do
  it "should require unique name within a study" do
  	t = Treatment.new(:study_id => 1, :name => 'T11')
    t.should be_valid
    assert t.save
  	t = Treatment.new(:study_id => 1, :name => 'T11')
    t.should_not be_valid
  end

  it "should require valid study" do
  	t = Treatment.new(:study_id => 1)
    t.should be_valid
  	t = Treatment.new(:study_id => 99)
    t.should_not be_valid
	end
end

