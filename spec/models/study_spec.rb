require 'spec_helper'

describe Study do
	it "should require unique name" do
		s = Study.new(:name => 'newname')
		assert s.save
		s = Study.new(:name => 'Main')
		assert !s.save
	end
end

