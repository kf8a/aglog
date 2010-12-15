require 'test_helper'

class MaterialTransactionTest < ActiveSupport::TestCase

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
        @transaction.rate = 4.0
        @material = Factory.create(:material, :k_content => 60)
        @unit = Factory.create(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      context "k_content_to_kg_ha" do
        should "be the appropriate number" do
          assert_equal 0.02, @transaction.k_content_to_kg_ha
        end
      end
    end
  end
end
