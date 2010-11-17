require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  fixtures :studies

	# name must be unique
	def test_name
		s = Study.new(:name => 'newname')
		assert s.save
		s = Study.new(:name => 'Main')
		assert !s.save
	end
	
end
