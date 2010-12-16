module SetupsHelper

   def equipment
     @equipment ||= Equipment.order('name').collect {|x| [x.name, x.id] unless x.archived?}.compact
   end
   
end
