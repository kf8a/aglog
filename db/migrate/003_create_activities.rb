class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.column :person_id, :integer
      t.column :observation_id, :integer
      t.column :operation_type_id, :integer
      t.column :comment, :text
      t.column :hours, :float
    end
  end

  def self.down
    drop_table :activities
  end
end
