class CreateHazards < ActiveRecord::Migration
  def self.up
    create_table :hazards do |t|
    	t.column :name, :string
    	t.column :hazard_type, :string
    	t.column :chemical_name, :string
    	t.column :description, :text
    	t.column :notification, :text
    	t.column :exclusion_time_days, :float    	
    end
    create_table :hazards_people, :id => false do |t|
    	t.column :hazard_id, :integer
    	t.column :person_id, :integer
    end
    create_table :hazards_materials, :id => false do |t|
    	t.column :hazard_id, :integer
    	t.column :material_id, :integer
    end
    	
  end

  def self.down
  	drop_table :hazards_people 
  	drop_table :hazards_materials
    drop_table :hazards
  end
end
