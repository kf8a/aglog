class AddSiUnitBooleanToUnits < ActiveRecord::Migration
  def change
    add_column :units, :is_si_unit, :boolean, default: false
  end
end
