require 'factory_girl/step_definitions'
require "#{Rails.root}/db/seeds.rb"

class PersonSessionsController

  #override new in PersonSessionsController for easier testing
  def new
    person = Person.first
    self.current_user = person
    redirect_back_or_default '/observations'
  end
end