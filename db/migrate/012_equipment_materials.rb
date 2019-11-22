class EquipmentMaterials < ActiveRecord::Migration[5.0]
  def self.up
    create_table "equipment_materials", id: false do |t|
        t.column :equipment_id, :integer
        t.column :material_id, :integer
    end
  end

  def self.down
    drop_table "equipment_materials"
  end
end
