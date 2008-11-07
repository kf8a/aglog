class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.column :name, :string
      t.column :unit_id, :integer
      t.column :operation_type_id, :integer
    end
    Material.reset_column_information
    Material.new(:name => 'nothing').save
    Material.new(:name => 'seed corn', :operation_type_id => 3, :unit_id => 4).save
    Material.new(:name => 'seed wheat', :operation_type_id => 3, :unit_id => 4).save
    Material.new(:name => '60-0-0', :operation_type_id => 4, :unit_id => 6).save
    Material.new(:name => 'corn', :operation_type_id => 5, :unit_id => 5).save
    Material.new(:name => 'wheat', :operation_type_id => 5, :unit_id => 5).save
  end

  def self.down
    drop_table :materials
  end
end
