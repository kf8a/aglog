class ChangeEquipmentDescriptionToText < ActiveRecord::Migration[5.0]
  def change
    change_column :equipment, :description, :text
  end
end
