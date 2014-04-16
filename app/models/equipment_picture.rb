class EquipmentPicture < ActiveRecord::Base
  belongs_to :equipment
  mount_uploader :equipment_picture, EquipmentPictureUploader
end
