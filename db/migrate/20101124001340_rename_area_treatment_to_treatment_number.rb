class RenameAreaTreatmentToTreatmentNumber < ActiveRecord::Migration
  def self.up
    rename_column("areas", "treatment", "treatment_number")
  end

  def self.down
    rename_column("areas", "treatment_number", "treatment")
  end
end
