class CreateMaterialTypes < ActiveRecord::Migration[5.0]
  def self.up
    create_table :material_types do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :material_types
  end
end
