require 'spec_helper'

describe MaterialTransaction do
  it "should find fertilizations" do
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
        @transaction.rate = 4.0
        @material = find_or_factory(:material, :name => 'n_content_material', :n_content => 60)
        @unit = find_or_factory(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      describe "n_content_to_kg_ha" do
        it "should be the appropriate number" do
          assert_equal 0.02, @transaction.n_content_to_kg_ha
        end
      end
    end

    context "The transaction has rate and p_content and conversion_factor. " do
      before(:each) do
        @transaction.rate = 4.0
        @material = find_or_factory(:material, :name => 'p_content_material', :p_content => 60)
        @unit = find_or_factory(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      describe "p_content_to_kg_ha" do
        it "should be the appropriate number" do
          assert_equal 0.02, @transaction.p_content_to_kg_ha
        end
      end
    end

    context "The transaction has rate and k_content and conversion_factor. " do
      before(:each) do
        @transaction.rate = 400
        @material = find_or_factory(:material, :name => 'k_content_material', :k_content => 60)
        @unit = find_or_factory(:unit, :conversion_factor => 4.0)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      describe "k_content_to_kg_ha" do
        it "should be the appropriate number" do
          assert_equal 2.38, @transaction.k_content_to_kg_ha
        end
      end
    end

    context "The transaction has a unit. " do
      before(:each) do
        @transaction.unit = find_or_factory(:unit, :name => 'barrel')
        @transaction.material = find_or_factory(:material, :name => "Beets")
      end

      it 'should give a material and rate on material_with_rate' do
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

      it 'should just give material on material_with_rate' do
        @transaction.rate = 4
        assert_equal "Carrots", @transaction.material_with_rate
      end
    end

    context 'The transaction has a material.' do
      before(:each) do
        @material = @transaction.material = find_or_factory(:material, :name => 'Waste')
      end

      context 'The material is hazardous.' do
        before(:each) do
          @material.hazards << FactoryGirl.create(:hazard)
        end

        describe 'The hazardous transaction' do
          subject { @transaction }
          it { should be_hazardous }
        end
      end

      context 'The material is not hazardous.' do
        before(:each) do
          @material.stub(:hazards) { [] }
        end

        describe 'The nonhazardous transaction' do
          subject { @transaction }
          it { should_not be_hazardous }
        end
      end
    end
  end
end
