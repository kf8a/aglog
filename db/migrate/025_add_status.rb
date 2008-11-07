class AddStatus < ActiveRecord::Migration
  def self.up
    add_column :observations, :state, :string
  end

  def self.down
    remove_column :observations, :state
  end
end
