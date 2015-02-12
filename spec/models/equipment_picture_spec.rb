require 'rails_helper'

describe EquipmentPicture do
  it {is_expected.to belong_to :equipment}
end
