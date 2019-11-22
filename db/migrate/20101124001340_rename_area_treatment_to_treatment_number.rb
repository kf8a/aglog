class RenameAreaTreatmentToTreatmentNumber < ActiveRecord::Migration[5.0]
  def self.up
    rename_column("areas", "treatment", "treatment_number")
  end

  def self.down
    rename_column("areas", "treatment_number", "treatment")
  end
end
