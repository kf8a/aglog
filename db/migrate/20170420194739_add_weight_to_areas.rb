class AddWeightToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :weight, :integer, default: 100
  end
end
