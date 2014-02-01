class AreaCopier
  def self.copy_area_to_company(area, company)
    new_area = Area.create(name: area.name, company: company)
    area.children.each do |child|
      child_area = AreaCopier.copy_area_to_company(child, company)
      child_area.move_to_child_of(new_area)
    end
    new_area
  end
end
