module SetupsHelper
  def equipment
    @equipment ||=
      Equipment.order('name').map { |equipment| [equipment.name, equipment.id] unless equipment.archived? }.compact
  end
end
