# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spec_helper'

describe Person do
  it {should belong_to :company}
  it {should validate_presence_of :company}

  let(:test_name) {{given_name: 'Joe', sur_name: 'Simmons'}}

  describe 'naming restrictions' do
    before(:each) do

      company = find_or_factory(:company)
      @duplicate_person = FactoryGirl.create(:person, :given_name=>test_name[:given_name],
                                         :sur_name => test_name[:sur_name], :company_id => company.id)
      @duplicate_person.company = company
      assert @duplicate_person.save

      @person  = Person.new(:given_name => test_name[:given_name], :sur_name => test_name[:sur_name]) 
      @person.company = company
    end

    it "should require unique name" do
      expect(@person).to_not be_valid
    end

    it 'should be insensitive on the first name' do
      @person.given_name = @person.given_name.upcase
      expect(@person).not_to be_valid
    end

    it 'should be insensitive on the last name' do
      @person.sur_name.upcase!
      expect(@person).to_not be_valid
    end

    it 'should be insensitive to the first and last name' do
      @person.sur_name.upcase!
      @person.given_name.upcase!
      expect(@person).not_to be_valid
    end
  end

  it "should allow a new name person to be created" do
    num_of_persons =  Person.count()
    a = Person.new(:given_name => 'new', :sur_name => 'person') # is new name
    a.company = Company.new
    expect(a).to be_valid
    assert a.save
    assert_equal num_of_persons + 1, Person.count
  end

  it "should not allow a person with no name to be created" do
    expect(Person.new).to_not be_valid
  end

  it 'should allow the same name in a different company' do
    person  = Person.new(:given_name => test_name[:given_name], :sur_name => test_name[:sur_name]) 
    company = FactoryGirl.create(:company)
    person.company = company
    expect(person).to be_valid
  end
end

