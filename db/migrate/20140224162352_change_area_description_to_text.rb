class ChangeAreaDescriptionToText < ActiveRecord::Migration[5.0]
  def change
    change_column :areas, :description, :text
  end
end
