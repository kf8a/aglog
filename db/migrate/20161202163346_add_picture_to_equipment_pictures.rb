class AddPictureToEquipmentPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_pictures, :picture, :string
  end
end
