class AddPictureToEquipmentPictures < ActiveRecord::Migration
  def change
    add_column :equipment_pictures, :picture, :string
  end
end
