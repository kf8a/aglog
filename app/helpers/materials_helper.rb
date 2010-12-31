module MaterialsHelper
  def  set_material_type_ids
    @material_type_ids =  MaterialType.all.collect {|type| [type.name, type.id]}
  end

  def hazard_choices
    @hazards ||= Hazard.all
  end
end
