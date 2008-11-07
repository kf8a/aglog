require File.dirname(__FILE__) + '/../test_helper'

class TreatmentTest < Test::Unit::TestCase
  fixtures :treatments
  
  def test_uniqueness  	
  	t = Treatment.new(:study_id => 1, :name => 'T11')
  	assert t.save
  	t = Treatment.new(:study_id => 1, :name => 'T1')
  	assert !t.save
  end
  	
  # study must exist
  def test_study_exists
  	t = Treatment.new(:study_id => 1)
  	assert t.save
  	t = Treatment.new(:study_id => 99)
  	assert !t.save
	end
	
end
