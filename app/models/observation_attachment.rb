class ObservationAttachment < ActiveRecord::Base
  belongs_to :observation
  mount_uploader :attachment, NoteUploader
end
