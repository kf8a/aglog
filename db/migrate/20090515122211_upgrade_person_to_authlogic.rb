class UpgradePersonToAuthlogic < ActiveRecord::Migration[5.0]
  def self.up
    add_column :people, :persistence_token, :string
    add_column :people, :password_salt, :string
    add_column :people, :last_request_at, :datetime
    add_column :people, :created_at, :datetime
    add_column :people, :updated_at, :datetime
    rename_column :people, :open_id, :openid_identifier
  end

  def self.down
    rename_column :people, :openid_identifier, :open_id
    remove_column :people, :updated_at
    remove_column :people, :created_at
    remove_column :people, :last_request_at
    remove_column :people, :password_salt
    remove_column :people, :column_name
  end
end
