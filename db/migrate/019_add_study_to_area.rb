class AddStudyToArea < ActiveRecord::Migration[5.0]
  def self.up
    add_column 'areas', 'study', :string # end
  end

  def self.down
    remove_column 'areas', 'study'
  end
end
