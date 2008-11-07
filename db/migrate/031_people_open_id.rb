class PeopleOpenId < ActiveRecord::Migration
  def self.up
    add_column "people", "open_id", :string
  end

  def self.down
    remove_column "people", "open_id"
  end
end
