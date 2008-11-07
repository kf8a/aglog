class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.column :name, :string
      t.column :si_unit_id, :integer
      t.column :conversion_factor, :float
    end
    Unit.reset_column_information
    Unit.new(:name => 'gram').save
    Unit.new(:name => 'kilogram',:si_unit_id => 1, :conversion_factor => 1000).save
    Unit.new(:name => 'bushel').save
    Unit.new(:name => 'metric ton').save
    Unit.new(:name => 'fluid ounce').save
    Unit.new(:name => 'ounce').save
    Unit.new(:name => 'quart').save
  end

  def self.down
    drop_table :units
  end
end
