class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
    	# t.timestamps 
    	t.column :name, :string
    	t.column :description, :text
    end
    Study.reset_column_information
    Study.create(:name => 'MAIN')
    Study.create(:name => 'Biodiversity')
    Study.create(:name => 'Fertility Gradient')
    Study.create(:name => 'Irrigated Fertility Gradient')
    Study.create(:name => 'Rotation Entry Point')
  end

  def self.down
    drop_table :studies
  end
end
