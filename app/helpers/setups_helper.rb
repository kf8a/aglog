module SetupsHelper
  def equipment
    @equipment ||= Equipment.order('name').collect do |equipment|
      [equipment.name, equipment.id] unless equipment.archived?
    end.compact
  end
end
