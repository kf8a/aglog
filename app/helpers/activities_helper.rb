# helper methods for activity views
module ActivitiesHelper
  def people
    @people ||= Person.order('sur_name, given_name').map { |person| [person.name, person.id] }
  end
end
