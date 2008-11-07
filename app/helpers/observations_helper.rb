module ObservationsHelper
  def initializeArrays(activities)
    data = "arrayActivityIndexes = [];"
    activities.each do |activity|
      data << "arrayActivityIndexes.push(#{activity.id});"
    end
    javascript_tag(data)
  end

  def initializeArrays
     data = "arrayActivityIndexes = []; arraySetupIndexes=[];"
     javascript_tag(data)
   end
   
   def set_form_dropdowns
     @people =  Person.find(:all, :order => 'sur_name, given_name').collect {|x|  [x.name, x.id]}
     @equipment = Equipment.find(:all, :order => 'name').collect {|x| [x.name, x.id]}
     @materials =  Material.find(:all, :order => 'material_type_id, name').collect {|x| [x.name, x.id]}
     @units = Unit.find(:all, :order => 'name').collect {|x| [x.name, x.id]}
   end
   
   def  set_observation_types
     @observation_type_ids =  ObservationType.find(:all).collect {|x| [x.name, x.id]}
   end
   

end
