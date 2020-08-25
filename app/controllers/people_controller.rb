# Allows modification and viewing of people
class PeopleController < ApplicationController
  respond_to :json, :html

  # GET /people
  # GET /people.xml
  def index
    @people = params[:current] ? Person.current.ordered : Person.ordered
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
    @person = Person.find_in_company(current_user.companies, params[:id])
    respond_with @person
  end

  def create
    @person = Person.new(person_params) # into? The current user default one?
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      respond_with @person
    else
      render :new
    end
  end

  def update
    @person = Person.find_in_company(current_user.companies, params[:id])
    flash[:notice] = 'Person was successfully updated.' if @person.update_attributes(person_params)
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
  end # @person = Person.by_company(current_user.company).find(params[:id])
end
