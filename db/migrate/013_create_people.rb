class CreatePeople < ActiveRecord::Migration[5.0]
  def self.up
    create_table :people do |t|
      t.column :given_name, :string
      t.column :sur_name, :string
    end
  end

  def self.down
    drop_table :people
  end
end
