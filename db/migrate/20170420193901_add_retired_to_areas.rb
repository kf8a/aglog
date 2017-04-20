class AddRetiredToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :retired, :bool
  end
end
