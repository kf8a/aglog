require 'rails_helper'

describe Activity do
  describe "an activity with a valid user" do
    person = Person.new
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

  describe "a valid activity with hours inputted as '1,000'" do
    pending 'this should be handled in the view layer'
  end
end

