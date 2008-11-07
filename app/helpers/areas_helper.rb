module AreasHelper
  def set_form_dropdowns
    @studies =  Study.find(:all).collect {|x|  [x.name, x.id]}
    @treatments = Treatment.find(:all).collect {|x| [x.name, x.id]}
  end
  
end
