class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipment do |t|
      t.column :name, :string
      t.column :use_material, :boolean, :default => false
      t.column :is_tractor,  :boolean,  :default => false
    end
    create_table :equipment_operation_types , :id => false do |t|
       t.column :equipment_id, :integer
       t.column :operation_type_id, :integer
     end
    
    Equipment.reset_column_information
    Equipment.new(:name => "John Deere 5220 Tractor",:is_tractor => true).save
    Equipment.new(:name => "Gandy Air Seeder", :use_material => true).save
    Equipment.new(:name => "John Deere 7520 Tractor",  :is_tractor => true).save
    Equipment.new(:name => 'John Deere 714 Chisel plow').save
    Equipment.new(:name => "John Deere 7420a Tractor",  :is_tractor => true).save
    Equipment.new(:name => "John Deere 115 flail shredder").save
    Equipment.new(:name => "Top Air Sprayer", :use_material => true).save
    Equipment.new(:name => "John Deere 726 soil finisher").save
    Equipment.new(:name => "John Deere 1730 Maxemerge Plus Planter", :use_material => true).save
    Equipment.new(:name => "Rotary Hoe").save
    Equipment.new(:name => 'Hay tedder').save
    Equipment.new(:name => "John Deere 2155 Tractor", :is_tractor => true).save
    Equipment.new(:name => "New Holland Baler", :use_material => true).save
    Equipment.new(:name => "John Deere 10' brushhog mower").save
    Equipment.new(:name => 'Willmar spreader', :use_material => true).save
    Equipment.new(:name => "John Deere 6420 Tractor", :is_tractor => true).save
     Equipment.new(:name => 'John Deere 6 Row Corn Harvester', :is_tractor => true).save
    
  end

  def self.down
    drop_table :equipment_operation_types
    drop_table :equipment
  end
end
