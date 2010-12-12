module SetupsHelper

   def equipment
     @equipment ||= Equipment.find(:all, :order => 'name').collect {|x| [x.name, x.id]}
   end
   
end
