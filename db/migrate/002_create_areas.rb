class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.column :name, :string
      t.column :treatment, :integer
      t.column :replicate, :integer
    end
    Area.reset_column_information
    1.upto(7) do |treat|
      1.upto(6) do |rep|
        Area.new(:name => "T#{treat}R#{rep}", :treatment => treat, :replicate => rep).save
      end
    end
   end

  def self.down
    drop_table :areas
  end
end
