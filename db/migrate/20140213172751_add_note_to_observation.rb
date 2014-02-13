class AddNoteToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :note, :string
  end
end
