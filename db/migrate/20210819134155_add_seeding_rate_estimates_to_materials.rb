class AddSeedingRateEstimatesToMaterials < ActiveRecord::Migration[6.1]
  def change
    add_column :materials, :seeds_per_pound, :float
    add_column :materials, :pounds_per_bushel, :float
    add_column :materials, :default_planting_density, :float
  end
end
