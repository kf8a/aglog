# Allows modification and viewing of people
class PeopleController < ApplicationController

  # GET /people
  # GET /people.xml
  def index
    if current_user
      @people = Person.by_company(current_user.company).order('given_name').all
    else
      @people = Person.order('given_name').all
    end 
    respond_with @people
  end

  def show
    @person = Person.find(params[:id])
    respond_with @person
  end

  def new
    @person = Person.new
    respond_with @person
  end

  def edit
    @person = Person.by_company(current_user.company).find(params[:id])
    respond_with @person
  end

  def create
    @person = Person.new(params[:person])
    @person.company = current_user.company
    if @person.save
      flash[:notice] = 'Person was successfully created.'
    end
    respond_with @person
  end

  def update
    @person = Person.by_company(current_user.company).find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
    end
    respond_with @person
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    respond_with @person
  end

end
