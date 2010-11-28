require 'test_helper'

class EquipmentTest < ActiveSupport::TestCase

  setup do
    Factory.create(:equipment) unless Equipment.first
  end
  
  should validate_uniqueness_of(:name).case_insensitive

end
