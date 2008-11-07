module ReportsHelper
  def to_kg_ha(rate, content, material, unit)
    rate = rate * unit.conversion_factor
    rate = material.to_mass(rate)
    rate = rate/1000.0
    rate = rate / 0.404
    rate = rate * content / 100.0 
    rate = (rate * 100).round / 100.0
  end
end
