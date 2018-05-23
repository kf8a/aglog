class AddDefaultToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :default_company, :boolean, default: false
  end
end
