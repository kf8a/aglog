class CreateCollaborations < ActiveRecord::Migration[5.0]
  def change
    create_table :collaborations do |t|
      t.integer :project_id
      t.integer :person_id

      t.timestamps null: false
    end
  end
end
