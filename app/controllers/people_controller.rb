# Allows modification and viewing of people
class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    if current_user
      @people = Person.ordered_in_company(current_user.company)
    else
      @people = Person.ordered
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
    # @person = Person.by_company(current_user.company).find(params[:id])
    @person = Person.find_in_company(current_user.company, params[:id])
    respond_with @person
  end

  def create
    @person = Person.new(person_params)
    @person.company = current_user.company
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      respond_with @person
    else
      render :new
    end
  end

  def update
    @person = Person.find_in_company(current_user.company, params[:id])
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
    params.require(:person).permit(:given_name, :sur_name, :company_id, :archived)
  end
end
