class CreateObservations < ActiveRecord::Migration
  def self.up
    create_table :observations do |t|
      t.column :person_id, :integer   #this is the user  that made the observation ie. currently logged in
      t.column :comment, :text
      t.column :obs_date, :date
      t.column :created_on, :date
    end
    create_table :areas_observations, :id => false do |t|
      t.column :observation_id, :integer
      t.column :area_id, :integer
    end
  end

  def self.down
    drop_table :areas_observations
    drop_table :observations
  end
end
