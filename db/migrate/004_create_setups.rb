class CreateSetups < ActiveRecord::Migration
  def self.up
    create_table :setups do |t|
      t.column :activity_id, :integer
      t.column :equipment_id, :integer
      t.column :settings, :string
    end
  end

  def self.down
    drop_table :setups
  end
end
