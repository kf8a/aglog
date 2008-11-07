class AddBiodiversityPlots < ActiveRecord::Migration
  def self.up
    #add biodiversity
    1.upto(21) do |treat|
      1.upto(4) do |rep|
        Area.create(:name => "B#{treat}R#{rep}", :treatment => treat, :replicate => rep)
      end
    end
    #add N rate study
    1.upto(9) do |treat|
      1.upto(4) do |rep|
        Area.create(:name => "F#{treat}R#{rep}", :treatment => treat, :replicate => rep)
      end
    end
  end

  def self.down
  end
end
