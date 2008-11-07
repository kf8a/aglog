class AddIrrigatedFertilityGradient < ActiveRecord::Migration
  def self.up
    #add irrigated N rate study
    1.upto(9) do |treat|
      1.upto(4) do |rep|
        Area.create(:name => "iF#{treat}R#{rep}", :treatment => treat, :replicate => rep)
      end
    end
  end

  def self.down
  end
end
