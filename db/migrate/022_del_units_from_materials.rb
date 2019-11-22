class DelUnitsFromMaterials < ActiveRecord::Migration[5.0]
  def self.up
    remove_column "materials", "unit_id"
  end

  def self.down
    add_column "materials", "unit_id", :integer
  end
end
