class CreateUnits < ActiveRecord::Migration[5.0]
  def self.up
    create_table :units do |t|
      t.column :name, :string
      t.column :si_unit_id, :integer
      t.column :conversion_factor, :float
    end
  end

  def self.down
    drop_table :units
  end
end
