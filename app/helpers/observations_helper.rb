module ObservationsHelper

  def initialize_arrays
    data = "arrayActivityIndexes = []; arraySetupIndexes=[];"
    javascript_tag(data)
  end
   
  def observation_type_ids
    @observation_type_ids ||= ObservationType.all.collect do |type|
      [type.name, type.id]
    end
  end
   
end
