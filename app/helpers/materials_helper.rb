module MaterialsHelper
  def  set_material_type_ids
    @material_type_ids =  MaterialType.find(:all).collect {|x| [x.name, x.id]}
  end
end
