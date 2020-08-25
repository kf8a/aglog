class CreateStudies < ActiveRecord::Migration[5.0]
  def self.up
    create_table :studies do |t|
      # t.timestamps
      t.column :name,
                             :string
      t.column :description, :text
    end
  end

  def self.down
    drop_table :studies
  end
end
