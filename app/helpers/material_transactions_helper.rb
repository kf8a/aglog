module MaterialTransactionsHelper

  def materials
    @materials ||= Material.order('material_type_id, name').collect {|x| [x.name, x.id]}
  end

  def units
    @units ||= Unit.order('name').collect {|x| [x.name, x.id]}
  end

end
