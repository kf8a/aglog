module AreasHelper
  def set_form_dropdowns
    #@studies =  Study.all# .collect {|x| [x.name, x.id]}
    #@treatments = Treatment.find(:all).collect {|x| [x.name, x.id]}
  end

  def studies
    @studies ||= Study.all
  end

  def treatments
    @treatments ||= Treatment.all
  end
  
end
