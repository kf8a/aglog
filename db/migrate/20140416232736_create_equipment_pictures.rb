class CreateEquipmentPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_pictures do |t|
      t.integer :equipment_id
      t.string :title
      t.text   :description
      t.timestamps
    end
  end
end
