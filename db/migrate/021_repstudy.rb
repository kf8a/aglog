class Repstudy < ActiveRecord::Migration
  def self.up
    1.upto(4) do |t|
      1.upto(3) do  |e|
        1.upto(4)  do |r|
          Area.create(:name => "REPT#{t}E#{e}R#{r}", :replicate => "#{r}", :treatment => "#{t}#{e}")
        end
      end
    end
  end

  def self.down
  end
end
