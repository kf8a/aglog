class AddDescriptionAndArchiveToEquipment < ActiveRecord::Migration[5.0]
  def self.up
    add_column :equipment, :description, :string
    add_column :equipment, :archived, :boolean
  end

  def self.down
    remove_column :equipment, :description
    remove_column :equipment, :archived
  end
end
