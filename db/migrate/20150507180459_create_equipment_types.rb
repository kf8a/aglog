class CreateEquipmentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_types do |t|
      t.string :name, unique: true
      t.timestamps null: false
    end

    add_column :equipment, :equipment_type_id, :integer
  end
end
