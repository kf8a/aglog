# helpers for material view
module MaterialTransactionsHelper
  def materials
    @materials ||= Material.order('material_type_id, name')
                           .collect do |material|
      [material.name, material.id]
    end
  end

  def units
    @units ||= Unit.order('name').collect { |unit| [unit.name, unit.id] }
  end
end
