class CreateObservationTypes < ActiveRecord::Migration
  def self.up
    create_table :observation_types_observations, :id => false do |t|
      t.column :observation_id, :integer
      t.column :observation_type_id,  :integer
    end
    
    create_table :observation_types do |t|
      t.column  :name, :string
    end
    
    ObservationType.reset_column_information
    ObservationType.create(:name => 'Soil Preparation')
    ObservationType.create(:name => 'Harvest')
    ObservationType.create(:name => 'Planting')
    ObservationType.create(:name => 'Fertilizer application')
    ObservationType.create(:name => 'Pesticide application')
    ObservationType.create(:name => 'Herbicide application')
    
    
  end

  def self.down
    drop_table :observation_types
    drop_table "observation_types_observations"
  end
end
