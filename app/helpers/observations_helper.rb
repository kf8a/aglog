module ObservationsHelper

  def initialize_arrays
    data = "arrayActivityIndexes = []; arraySetupIndexes=[];"
    javascript_tag(data)
  end
   
  def observation_type_ids
    @observation_type_ids ||= ObservationType.all.collect {|x| [x.name, x.id]}
  end
   
end
