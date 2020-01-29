# frozen_string_literal: true

# Equipment types classify equipment
# for example Planter, Spreader, Tractor
class EquipmentPicture < ActiveRecord::Base
  belongs_to :equipment
  mount_uploader :picture, EquipmentPictureUploader
end
