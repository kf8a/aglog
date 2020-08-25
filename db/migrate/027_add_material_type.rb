class AddMaterialType < ActiveRecord::Migration[5.0]
  def self.up
    add_column 'materials', 'material_type_id', :integer
    add_column 'materials', 'n_content', :float
    add_column 'materials', 'p_content', :float
    add_column 'materials', 'k_content', :float
  end

  def self.down
    remove_column 'materials', 'material_type_id'
    remove_column 'materials', 'n_content'
    remove_column 'materials', 'p_content'
    remove_column 'materials', 'k_content'
  end
end
