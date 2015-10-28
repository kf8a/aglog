class AddMsuOwnedFlagToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :non_msu, :boolean, default: false
  end
end
