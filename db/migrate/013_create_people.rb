class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :given_name, :string
      t.column :sur_name, :string
    end
    Person.reset_column_information
    Person.create(:given_name => 'Joe', :sur_name => 'Simmons')
  end

  def self.down
    drop_table :people
  end
end
