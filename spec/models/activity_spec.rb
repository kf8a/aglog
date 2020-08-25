describe Activity do
  describe 'an activity with a valid user' do
    person = Person.new
    subject { Activity.new(person: person) }
    it { is_expected.to be_valid }
  end

  describe 'an activity with an invalid user' do
    before(:each) do
      @id = 1
      @id += 1 while Person.exists?(@id)
      assert !Person.exists?(@id)
    end

    subject { Activity.new(person_id: @id) }
    it { is_expected.to_not be_valid }
  end

  describe 'an activity with no user' do
    subject { Activity.new(person_id: nil) }
    it { is_expected.to_not be_valid }
  end

  describe "a valid activity with hours inputted as '1,000'" do
    pending 'this should be handled in the view layer'
  end
end
