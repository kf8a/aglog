require 'test_helper'

class MaterialTransactionTest < ActiveSupport::TestCase

  should "find fertilizations" do
    #This is very brittle and will need to be fixed eventually
    correct_transactions = MaterialTransaction.find(20, 19, 82, 235, 236, 640, 637, 622, 624, 626, 628, 645, 268, 270, 266, 298, 299, 328)
    assert_equal [], correct_transactions - MaterialTransaction.find_fertilizations
    assert_equal [], MaterialTransaction.find_fertilizations - correct_transactions
  end
  
  context "A material transaction exists. " do
    setup do
      @transaction = Factory.create(:material_transaction)
    end

    context "The transaction has rate and n_content and conversion_factor. " do
      setup do
        @transaction.rate = 4.0
        @material = Factory.create(:material, :n_content => 60)
        @unit = Factory.create(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end
      
      context "n_content_to_kg_ha" do
        should "be the appropriate number" do
          assert_equal 0.02, @transaction.n_content_to_kg_ha
        end
      end
    end

    context "The transaction has rate and p_content and conversion_factor. " do
      setup do
        @transaction.rate = 4.0
        @material = Factory.create(:material, :p_content => 60)
        @unit = Factory.create(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      context "p_content_to_kg_ha" do
        should "be the appropriate number" do
          assert_equal 0.02, @transaction.p_content_to_kg_ha
        end
      end
    end

    context "The transaction has rate and k_content and conversion_factor. " do
      setup do
        @transaction.rate = 400
        @material = Factory.create(:material, :k_content => 60)
        @unit = Factory.create(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      context "k_content_to_kg_ha" do
        should "be the appropriate number" do
          assert_equal 2.38, @transaction.k_content_to_kg_ha
        end
      end
    end

    context "The transaction has a unit. " do
      setup do
        @transaction.unit = Factory.create(:unit, :name => 'barrel')
        @transaction.material = Factory.create(:material, :name => "Beets")
      end

      should 'give a material and rate on material_with_rate' do
        @transaction.rate = 4
        assert_equal "Beets: 4.0 barrels per acre", @transaction.material_with_rate

        @transaction.rate = 1
        assert_equal "Beets: 1.0 barrel per acre",  @transaction.material_with_rate
      end
    end

    context "The transaction does not have a unit. " do
      setup do
        @transaction.unit = nil
        @transaction.material = Factory.create(:material, :name => "Carrots")
      end

      should 'just give material on material_with_rate' do
        @transaction.rate = 4
        assert_equal "Carrots", @transaction.material_with_rate
      end
    end
  end
end
