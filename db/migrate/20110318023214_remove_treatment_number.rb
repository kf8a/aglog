class RemoveTreatmentNumber < ActiveRecord::Migration
  def self.up
    remove_column :areas, :treatment_number
    add_column :treatments, :treatment_number, :integer
  end

  def self.down
    remove_column :treatments, :treatment_number
    add_column :areas, :treatment_number, :integer
  end
end
