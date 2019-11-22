class AddSiUnitBooleanToUnits < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :is_si_unit, :boolean, default: false
  end
end
