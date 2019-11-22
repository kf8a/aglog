class AddSalusCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment, :salus_code, :text
    add_column :materials, :salus_code, :text
  end
end
