require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  def test_new_basic_activity
    num_activities = Activity.count
    a = Activity.new({:comment => 'This comment is blank'})
    assert !a.save
    assert_equal num_activities, Activity.count
  end
   
  def test_new_activity_with_user
    num_activities =  Activity.count
    a = Activity.new({:person => people(:people_001)})
    assert a.save
    assert_equal num_activities+1, Activity.count
  end
    
  def test_new_activity_with_invalid_user
    num_activities = Activity.count
    a = Activity.new({:person_id  => 44 })
    assert !a.save
    assert_equal num_activities, Activity.count
  end
      
  def test_new_activity_with_no_user
    num_activities = Activity.count
    a = Activity.new
    assert !a.save
    assert_equal num_activities, Activity.count
  end

  def test_person_name
    person = Factory.create(:person, :given_name => "Cool", :sur_name => "Name")
    person_activity = Factory.create(:activity, :person_id => person.id)

    assert_equal "Cool Name", person_activity.person_name
  end
end
