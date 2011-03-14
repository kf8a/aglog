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

     reset_column_information
    # upgrade old records
     company = Company.create(:name => 'LTER') 
     
     Observations.all.each do |observation|
       observation.company = company
       observation.save
     end

     Equipment.all.each do |e|
       e.company = company
       e.save
     end

     Person.all.each do |p|
       p.company = company
       p.save
     end

     Material.all.each do |m|
       m.company = company
       m.save
     end

     Areas.all.each do |a|
       a.company = company
       a.save
     end

     
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
