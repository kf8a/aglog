class AddRetiredToAreas < ActiveRecord::Migration[5.0]
  def change
    add_column :areas, :retired, :bool
  end
end
