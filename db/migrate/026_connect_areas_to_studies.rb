class ConnectAreasToStudies < ActiveRecord::Migration
  def self.up
    add_column "areas", "study_id", :integer
    remove_column "areas", "study"
  end

  def self.down
    remove_column "areas", "study_id"
    add_column "areas", "study", :string
  end
end
