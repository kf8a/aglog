class ChangeEquipmentDescriptionToText < ActiveRecord::Migration
  def change
    change_column :equipment, :description, :text
  end
end
