class AddNotesFieldToObservations < ActiveRecord::Migration[5.0]
  def change
    add_column :observations, :notes, :json
  end
end
