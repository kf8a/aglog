class AddNoteToObservation < ActiveRecord::Migration[5.0]
  def change
    add_column :observations, :note, :string
  end
end
