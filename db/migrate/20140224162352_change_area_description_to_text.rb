class ChangeAreaDescriptionToText < ActiveRecord::Migration
  def change
    change_column :areas, :description, :text
  end
end
