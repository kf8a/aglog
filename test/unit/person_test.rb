require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def test_should_not_create_duplicate
    given_name = 'Joe'
    sur_name = 'Simmons'
    
    a  = Person.new(:given_name => given_name, :sur_name => sur_name) # is in fixture already
    assert !a.save(:validate => true)
    assert !a.errors.empty?
    
    a  = Person.new(:given_name => given_name.upcase, :sur_name => sur_name) # case insensitive
    assert !a.save(:validate => true)
    assert !a.errors.empty?
    
    a  = Person.new(:given_name => given_name, :sur_name => sur_name.upcase) # case insensitive
    assert !a.save(:validate => true)
    assert !a.errors.empty?
  end
  
  def test_should_create_new_person
    num_of_persons =  Person.count()
    a = Person.new(:given_name => 'new', :sur_name => 'person') # is new name
    assert a.save(:validate => true)
    assert a.errors.empty?
    assert_equal num_of_persons + 1, Person.count
  end
  
  def test_create_person_with_no_name
    a  =  Person.new
    assert !a.save(:validate => true)
  end
  
end
