class AddEstimationSourceToMaterials < ActiveRecord::Migration[6.1]
  def change
    add_column :materials, :source, :text
  end
end
