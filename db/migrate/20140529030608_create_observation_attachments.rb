class CreateObservationAttachments < ActiveRecord::Migration
  def change
    create_table :observation_attachments do |t|
      t.integer :observation_id
      t.string :attachment

      t.timestamps
    end
  end
end
