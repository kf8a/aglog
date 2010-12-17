module ActivitiesHelper
   def people
     @people ||= Person.order('sur_name, given_name').collect {|x| [x.name, x.id]}
   end
end
