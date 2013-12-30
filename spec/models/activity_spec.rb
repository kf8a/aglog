require 'spec_helper'

describe Activity do
  describe "an activity with a valid user" do
    person = find_or_factory(:person)
    person.save
    subject { Activity.new(:person => person) }
    it { should be_valid }
  end

  describe "an activity with an invalid user" do
    before(:each) do
      @id = 1
      while Person.exists?(@id)
        @id += 1
      end
      assert !Person.exists?(@id)
    end
    
    subject { Activity.new(:person_id => @id) }
    it { should_not be_valid }
  end

  describe "an activity with no user" do
    subject { Activity.new(:person_id => nil) }
    it { should_not be_valid }
  end

  describe "a valid activity with a person named 'Cool Name'" do
    person = find_or_factory(:person, :given_name => "Cool", :sur_name => "Name")
    activity = Activity.new
    activity.person = person
    activity.person.should == person
  end

  describe "a valid activity with hours inputted as '1,000'" do
    subject { FactoryGirl.create(:activity, :hours => '1,000') }
    its(:hours) { should == 1000 }
  end
end

