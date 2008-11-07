class AddStudyToArea < ActiveRecord::Migration
  def self.up
    add_column "areas", "study", :string
    # Area.reset_column_information
    # areas = Area.find(:all)
    # areas.each do |area|
    #   area.study = 'MAIN'
    #   area.save
    # end
  end

  def self.down
    remove_column "areas", "study"
  end
end
