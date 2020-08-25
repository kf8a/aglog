class AddDeprecations < ActiveRecord::Migration[5.0]
  def self.up
    add_column :people, :archived, :boolean, default: false
    add_column :materials, :archived, :boolean, default: false
  end

  def self.down
    remove_column :materials, :archived
    remove_column :people, :archived
  end
end
