class AddDescriptionToArea < ActiveRecord::Migration[5.0]
  def self.up
    add_column :areas, :description, :string
  end

  def self.down
    remove_column :areas, :description
  end
end
