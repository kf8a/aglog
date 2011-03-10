# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spec_helper'

describe Person do
  it {should belong_to :company}
  it {should validate_presence_of :company}

  describe 'naming restrictions' do
    before(:each) do
      given_name = 'Joe'
      sur_name = 'Simmons'

      Factory.create(:person, :given_name=>given_name, :sur_name => sur_name)
      @person  = Person.new(:given_name => given_name, :sur_name => sur_name) 
      @person.company = Company.new
    end

    it "should require unique name" do
      assert !@person.save
      assert !@person.errors.empty?
    end

    it 'should be insensitive on the first name' do
      @person.given_name = @person.given_name.upcase
      assert !@person.save
      assert !@person.errors.empty?
    end

    it 'should be insensitive on the last name' do
      @person.sur_name = @person.sur_name.upcase
      assert !@person.save
      assert !@person.errors.empty?
    end
  end

  it "should allow a new name person to be created" do
    num_of_persons =  Person.count()
    a = Person.new(:given_name => 'new', :sur_name => 'person') # is new name
    a.company = Company.new
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_persons + 1, Person.count
  end

  it "should not allow a person with no name to be created" do
    a  =  Person.new
    assert !a.save
  end
end

