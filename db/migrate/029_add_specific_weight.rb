class AddSpecificWeight < ActiveRecord::Migration[5.0]
  def self.up
    add_column "materials", "specific_weight", :float, :default => 1
    add_column "materials", "liquid", :boolean
  end

  def self.down
    remove_column "materials", "specific_weight"
#    remove_column "materials", "liquid"
  end
end
