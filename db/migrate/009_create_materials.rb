class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.column :name, :string
      t.column :unit_id, :integer
      t.column :operation_type_id, :integer
    end
  end

  def self.down
    drop_table :materials
  end
end
