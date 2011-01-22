module MaterialsHelper
  def hazard_choices
    @hazards ||= Hazard.all
  end
end
