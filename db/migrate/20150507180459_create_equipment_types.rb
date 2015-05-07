class CreateEquipmentTypes < ActiveRecord::Migration
  def change
    create_table :equipment_types do |t|
      t.string :name, unique: true
      t.timestamps null: false
    end

    add_column :equipment, :equipment_type_id, :integer
  end
end
