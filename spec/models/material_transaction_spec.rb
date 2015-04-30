require 'rails_helper'

describe MaterialTransaction do
  it "finds fertilizations" do
    #TODO Rewrite this test with factory created fertilizations
#    correct_transactions = MaterialTransaction.find(20, 19, 82, 235, 236, 640, 637, 622, 624, 626, 628, 645, 268, 270, 266, 298, 299, 328)
#    found_fertilizations = MaterialTransaction.find_fertilizations
#    assert_equal [], correct_transactions - found_fertilizations
#    assert_equal [], found_fertilizations - correct_transactions
  end

  context "A material transaction exists. " do
    before(:each) do
      @transaction = MaterialTransaction.new
    end

    context "The transaction has rate and n_content and conversion_factor. " do
      before(:each) do
        @transaction.rate = 180.0
        @material = find_or_factory(:material, :name => 'n_content_material', :n_content => 46)
        @unit = find_or_factory(:unit, :conversion_factor => 453.592)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      describe "n_content_to_kg_ha" do
        it "is the appropriate number" do
          assert_equal 15.17, @transaction.n_content_to_kg_ha
        end
      end
    end

    context "The transaction has rate and p_content and conversion_factor. " do
      before(:each) do
        @transaction.rate = 14.0
        @material = find_or_factory(:material, :name => 'p_content_material', :p_content => 43.64)
        @unit = find_or_factory(:unit, :conversion_factor => 453.592)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      describe "p_content_to_kg_ha" do
        it "is the appropriate number" do
          assert_equal 1.12, @transaction.p_content_to_kg_ha
        end
      end
    end

    context "The transaction has rate and k_content and conversion_factor. K2O" do
      before(:each) do
        @transaction.rate = 120
        @material = find_or_factory(:material, :name => 'k_content_material', :k_content => 49.8)
        @unit = find_or_factory(:unit, :conversion_factor => 453.592)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      describe "k_content_to_kg_ha" do
        it "is the appropriate number" do
          assert_equal 10.95, @transaction.k_content_to_kg_ha
        end
      end
    end

    context "The transaction has a unit. " do
      before(:each) do
        @transaction.unit = find_or_factory(:unit, :name => 'barrel')
        @transaction.material = find_or_factory(:material, :name => "Beets")
      end

      it 'returns a material and rate on material_with_rate' do
        @transaction.rate = 4
        assert_equal "Beets: 4.0 barrels per acre", @transaction.material_with_rate

        @transaction.rate = 1
        assert_equal "Beets: 1.0 barrel per acre",  @transaction.material_with_rate
      end
    end

    context "The transaction does not have a unit. " do
      before(:each) do
        @transaction.unit = nil
        @transaction.material = find_or_factory(:material, :name => "Carrots")
      end

      it 'returns just material on material_with_rate' do
        @transaction.rate = 4
        assert_equal "Carrots", @transaction.material_with_rate
      end
    end
  end
end
