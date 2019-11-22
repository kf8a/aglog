class AddMsuOwnedFlagToEquipment < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment, :non_msu, :boolean, default: false
  end
end
