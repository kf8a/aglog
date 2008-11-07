class AddSpecificWeight < ActiveRecord::Migration
  def self.up
    add_column "materials", "specific_weight", :float, :default => 1
    add_column "materials", "liquid", :boolean
    Material.reset_column_information
    Material.find(:all).each do |m|
      m.specific_weight = 1
      m.save
    end
  end

  def self.down
    remove_column "materials", "specific_weight"
#    remove_column "materials", "liquid"
  end
end
