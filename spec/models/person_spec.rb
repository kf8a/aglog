# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spec_helper'

describe Person do
  it {should belong_to :company}

  it "should require unique name" do
    given_name = 'Joe'
    sur_name = 'Simmons'

    a  = Person.new(:given_name => given_name, :sur_name => sur_name) # is in fixture already
    assert !a.save
    assert !a.errors.empty?

    a  = Person.new(:given_name => given_name.upcase, :sur_name => sur_name) # case insensitive
    assert !a.save
    assert !a.errors.empty?

    a  = Person.new(:given_name => given_name, :sur_name => sur_name.upcase) # case insensitive
    assert !a.save
    assert !a.errors.empty?
  end

  it "should allow a new name person to be created" do
    num_of_persons =  Person.count()
    a = Person.new(:given_name => 'new', :sur_name => 'person') # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_persons + 1, Person.count
  end

  it "should not allow a person with no name to be created" do
    a  =  Person.new
    assert !a.save
  end
end

