class AddNotesFieldToObservations < ActiveRecord::Migration
  def change
    add_column :observations, :notes, :json
  end
end
