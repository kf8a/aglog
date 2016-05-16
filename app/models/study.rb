# Groups of areas belong to different studies.
class Study < ActiveRecord::Base
  has_many :areas
  has_many :treatments

  validates :name, uniqueness: { case_sensitive: false }

  def to_label
    description.presence || name
  end
end
