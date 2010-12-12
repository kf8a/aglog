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
   
   def units
     @units ||= Unit.find(:all, :order => 'name').collect {|x| [x.name, x.id]}
   end

   def materials
     @materials ||= Material.find(:all, :order => 'material_type_id, name').collect {|x| [x.name, x.id]}
   end
   
   def observation_type_ids
     @observation_type_ids ||= ObservationType.find(:all).collect {|x| [x.name, x.id]}
   end
   

end
