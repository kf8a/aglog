module ActivitiesHelper
   def people
     @people ||= Person.order('sur_name, given_name').collect do |person|
       [person.name, person.id]
     end
   end
end
