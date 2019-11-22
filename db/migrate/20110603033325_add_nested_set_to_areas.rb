class AddNestedSetToAreas < ActiveRecord::Migration[5.0]
  def self.up
    add_column :areas,    :lft,       :integer
    add_column :areas,    :rgt,       :integer
    add_column :areas,    :parent_id, :integer
  end

  def self.down
    remove_column :areas, :lft
    remove_column :areas, :rgt
    remove_column :areas, :parent_id
  end
end
