module AreasHelper
  def set_form_dropdowns
    #@studies =  Study.all# .collect {|x| [x.name, x.id]}
    #@treatments = Treatment.find(:all).collect {|x| [x.name, x.id]}
  end

  def study_options(area)
    options_from_collection_for_select(studies, 'id', 'name', area.study_id)
  end

  def treatment_options(area)
    options_from_collection_for_select(treatments, 'id', 'name', area.treatment_id)
  end

  def studies
    @studies ||= Study.all
  end

  def treatments
    @treatments ||= Treatment.all
  end
  
end
