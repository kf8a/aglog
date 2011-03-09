class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name 

      t.timestamps
    end

    add_column :observations, :company_id, :integer
    add_column :equipment, :company_id, :integer
    add_column :people, :company_id, :integer
    add_column :materials, :company_id, :integer
    add_column :areas, :company_id, :integer
  end

  def self.down
    remove_column :observations, :company_id
    remove_column :equipment, :company_id
    remove_column :people,:company_id
    remove_column :materials, :company_id
    remove_column :areas, :company_id
    drop_table :companies
  end
end
