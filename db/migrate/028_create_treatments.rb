class CreateTreatments < ActiveRecord::Migration
  def self.up
    create_table :treatments do |t|
      t.string :name
      t.integer :study_id
    end
    add_column "areas", "treatment_id", :integer
  end

  def self.down
    drop_table :treatments
    remove_column "areas", "treatment_id"
  end
end
