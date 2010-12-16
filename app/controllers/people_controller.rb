class PeopleController < ApplicationController

  # GET /people
  # GET /people.xml
  def index
    @people = Person.order('given_name')
    respond_with @people
  end

end
