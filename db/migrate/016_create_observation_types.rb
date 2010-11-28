class CreateObservationTypes < ActiveRecord::Migration
  def self.up
    create_table :observation_types_observations, :id => false do |t|
      t.column :observation_id, :integer
      t.column :observation_type_id,  :integer
    end
    
    create_table :observation_types do |t|
      t.column  :name, :string
    end
  end

  def self.down
    drop_table :observation_types
    drop_table "observation_types_observations"
  end
end
