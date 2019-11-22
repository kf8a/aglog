class PeopleOpenId < ActiveRecord::Migration[5.0]
  def self.up
    add_column "people", "open_id", :string
  end

  def self.down
    remove_column "people", "open_id"
  end
end
