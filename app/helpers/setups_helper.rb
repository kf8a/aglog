module SetupsHelper
  def equipment
    @equipment ||= Equipment.order('name').map do |equipment|
      [equipment.name, equipment.id] unless equipment.archived?
    end.compact
  end
end
