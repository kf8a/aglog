# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rails_helper'

describe Person do

  let(:test_name) {{given_name: 'Joe', sur_name: 'Simmons'}}

  describe 'naming restrictions' do
    before(:each) do

      company = find_or_factory(:company)
      @duplicate_person = FactoryBot.build(:person, given_name: test_name[:given_name],
                                           sur_name: test_name[:sur_name])
      @duplicate_person.companies = [company]
      assert @duplicate_person.save

      @person  = Person.new(given_name: test_name[:given_name], sur_name: test_name[:sur_name])
      @person.companies = [company]
    end

    it "requires unique name" do
      expect(@person).to_not be_valid
    end

    it 'is insensitive on the first name' do
      @person.given_name = @person.given_name.upcase
      expect(@person).not_to be_valid
    end

    it 'is insensitive on the last name' do
      @person.sur_name.upcase!
      expect(@person).to_not be_valid
    end

    it 'is insensitive to the first and last name' do
      @person.sur_name.upcase!
      @person.given_name.upcase!
      expect(@person).not_to be_valid
    end
  end

  it "allows a new name person to be created" do
    a = Person.new(given_name: 'new', sur_name: 'person') # is new name
    a.companies = [Company.new]
    expect(a).to be_valid
  end

  it "does not allow a person with no name to be created" do
    expect(Person.new).to_not be_valid
  end

  it 'allows the same name in a different company' do
    person  = Person.new(given_name: test_name[:given_name], sur_name: test_name[:sur_name])
    company = FactoryBot.create(:company)
    person.companies = [company]
    expect(person).to be_valid
  end

  it 'returns a list of companies' do
    person  = Person.new(given_name: test_name[:given_name], sur_name: test_name[:sur_name])
    company = FactoryBot.build(:company)
    person.companies << company
    expect(person.companies).to eq [company]
  end

  it 'does not allow a person with no company'

end

