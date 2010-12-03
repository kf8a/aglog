class PeopleController < ApplicationController
  before_filter :get_person, :only => [:show, :edit, :update, :destroy]
  respond_to :html, :xml

  # GET /people
  # GET /people.xml
  def index
    @people = Person.order('given_name')
    respond_with @people
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    respond_with @person
  end

  # GET /people/new
  def new
    @person = Person.new
    respond_with @person
  end

  # GET /people/1;edit
  def edit
    respond_with @person
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
    end
    respond_with @person
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
    end
    respond_with @person
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person.destroy
    respond_with @person
  end

  private ##################

  def get_person
    @person = Person.find(params[:id])
  end
end
