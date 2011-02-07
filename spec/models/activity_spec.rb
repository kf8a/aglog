require 'spec_helper'

describe Activity do
  describe "an activity with a valid user" do
    person = find_or_factory(:person)
    subject { Activity.new(:person => person) }
    it { should be_valid }
  end

  describe "an activity with an invalid user" do
    id = 1
    while Person.exists?(id)
      id += 1
    end
    subject { Activity.new(:person_id => id) }
    it { should_not be_valid }
  end

  describe "an activity with no user" do
    subject { Activity.new(:person_id => nil) }
    it { should_not be_valid }
  end

  describe "a valid activity with a person named 'Cool Name'" do
    person = find_or_factory(:person, :given_name => "Cool", :sur_name => "Name")
    subject { Factory.create(:activity, :person_id => person.id) }
    its(:person_name) { should match('Cool Name') }
  end
end

