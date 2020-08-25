class CreateEquipment < ActiveRecord::Migration[5.0]
  def self.up
    create_table :equipment do |t|
      t.column :name, :string
      t.column :use_material, :boolean, default: false
      t.column :is_tractor, :boolean, default: false
    end
    create_table :equipment_operation_types, id: false do |t|
      t.column :equipment_id, :integer
      t.column :operation_type_id, :integer
    end
  end

  def self.down
    drop_table :equipment_operation_types
    drop_table :equipment
  end
end
