class RemoveHazards < ActiveRecord::Migration[5.0]
  def change
    drop_table :hazards
    drop_table :hazards_materials
    drop_table :hazards_people
  end
end
