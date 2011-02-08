require 'spec_helper'

describe Treatment do
  it "should require unique name within a study" do
  	t = Treatment.new(:study_id => 1, :name => 'T11')
  	assert t.save
  	t = Treatment.new(:study_id => 1, :name => 'T11')
  	assert !t.save
  end

  it "should require valid study" do
  	t = Treatment.new(:study_id => 1)
  	assert t.save
  	t = Treatment.new(:study_id => 99)
  	assert !t.save
	end
end

