class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.integer :company_id
      t.integer :person_id

      t.timestamps null: false
    end
  end
end
