class CreateAreas < ActiveRecord::Migration[5.0]
  def self.up
    create_table :areas do |t|
      t.column :name, :string
      t.column :treatment, :integer
      t.column :replicate, :integer
    end
  end

  def self.down
    drop_table :areas
  end
end
