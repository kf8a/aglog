require 'test_helper'

class MaterialTest < ActiveSupport::TestCase
  
  def test_uniqueness
    num_of_items =  Material.count()
    test_name = 'seed corn'
    a  = Material.new(:name => test_name) # is in fixture already
    assert !a.save
    assert !a.errors.empty?
    
    a  = Material.new(:name => test_name.upcase) # case insensitive
    assert !a.save
    assert !a.errors.empty?
    
    a = Material.new(:name => 'A New Material') # is new name
    assert a.save
    assert a.errors.empty?
    assert_equal num_of_items + 1, Material.count
  end

  context "A material exists that is liquid. " do
    setup do
      @material = Factory.create(:material, :liquid => true)
    end

    context "to_mass(amount)" do
      should "be the right number" do
        assert_equal 4000, @material.to_mass(4)
      end
    end
  end

  should 'grab all and only the right its own observations with self.observations' do
    @material = Factory.create(:material, :name => 'correct material')

    included_observation_first = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => included_observation_first.id)
    setup = Factory.create(:setup, :activity_id => activity.id)
    Factory.create(:material_transaction, :setup_id => setup.id, :material_id => @material.id)

    included_observation_second = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => included_observation_second.id)
    setup = Factory.create(:setup, :activity_id => activity.id)
    Factory.create(:material_transaction, :setup_id => setup.id, :material_id => @material.id)

    evil_material = Factory.create(:material, :name => 'evil material')
    not_included_observation = Factory.create(:observation)
    activity = Factory.create(:activity, :observation_id => not_included_observation.id)
    setup = Factory.create(:setup, :activity_id => activity.id)
    Factory.create(:material_transaction, :setup_id => setup.id, :material_id => evil_material.id)

    @material.reload
    assert @material.observations.include?(included_observation_first)
    assert @material.observations.include?(included_observation_second)
    assert !@material.observations.include?(not_included_observation)
  end

  context 'A material with a material type' do
    setup do
      @material_type = Factory.create(:material_type, :name => 'Testable Name')
      @material = Factory.create(:material, :material_type_id => @material_type.id)
    end

    should 'return the name of the material type on material_type_name' do
      assert_equal @material_type.name, @material.material_type_name
    end
  end

  context 'An area with no study' do
    setup do
      @area = Factory.create(:area, :study_id => nil)
    end

    should 'return nil for study_name' do
      assert_equal nil, @area.study_name
    end
  end
  
end
