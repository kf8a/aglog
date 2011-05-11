class AddDeprecations < ActiveRecord::Migration
  def self.up
    add_column :people,    :archived, :boolean
    add_column :materials, :archived, :boolean
  end

  def self.down
    remove_column :materials, :archived
    remove_column :people,    :archived
  end
end
