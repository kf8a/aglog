# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def set_hazard_ids
    @hazard_ids =  Hazard.find(:all).collect {|x| [x.name, x.id]}
  end

end
