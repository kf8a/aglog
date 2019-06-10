# Allows modification and viewing of people
class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @people = Person.ordered
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
    # @person = Person.by_company(current_user.company).find(params[:id])
    @person = Person.find_in_company(current_user.companies, params[:id])
    respond_with @person
  end

  def create
    @person = Person.new(person_params)
    # TODO: how does it work when I create a person. Which company do they go
    # into? The current user default one?
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      respond_with @person
    else
      render :new
    end
  end

  def update
    @person = Person.find_in_company(current_user.companies, params[:id])
    if @person.update_attributes(person_params)
      flash[:notice] = 'Person was successfully updated.'
    end
    respond_with @person
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    redirect_to people_url
  end

  private

  def person_params
    params.require(:person).permit(:given_name, :sur_name, :companies, :archived)
  end
end
