class DelUnitsFromMaterials < ActiveRecord::Migration
  def self.up
    remove_column "materials", "unit_id"
  end

  def self.down
    add_column "materials", "unit_id", :integer
  end
end
