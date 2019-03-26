describe MaterialTransaction do

  context "A material transaction " do
    before(:each) do
      @transaction = MaterialTransaction.new
    end

    context "180 lb of 46-0-0 " do
      before(:each) do
        @transaction.rate = 180.0
        @material = find_or_factory(:material, :name => 'n_content_material', :n_content => 46)
        @unit = find_or_factory(:unit, :conversion_factor => 453.592)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      it "provides 92.7 kg N/ha " do
        assert_equal 92.77, @transaction.n_content_to_kg_ha
      end
    end

    describe '16 gal of 28-0-0 ' do
      before do
        @transaction.rate = 16
        @material = find_or_factory(:material, name: 'n_content_material', n_content: 28, liquid: true, specific_weight: 1.28)
        @unit = find_or_factory(:unit, :conversion_factor => 3785.41)
        @transaction.material = @material
        @transaction.unit = @unit
      end
      it 'provides 53.6 kg N/ha' do
        assert_equal 53.62, @transaction.n_content_to_kg_ha
      end
    end

    context "14 lb/A of P2O5 " do
      before(:each) do
        @transaction.rate = 14.0
        @material = find_or_factory(:material, :name => 'p_content_material', :p_content => 43.64)
        @unit = find_or_factory(:unit, :conversion_factor => 453.592)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      it "provides 6.85 kg P/ha" do
        assert_equal 6.85, @transaction.p_content_to_kg_ha
      end
    end

    context "120 lb of K2O/A " do
      before(:each) do
        @transaction.rate = 120
        @material = find_or_factory(:material, :name => 'k_content_material', :k_content => 49.8)
        @unit = find_or_factory(:unit, :conversion_factor => 453.592)
        @transaction.material = @material
        @transaction.unit = @unit
      end

      it "provides 66.95 kg K/ha" do
        assert_equal 66.95, @transaction.k_content_to_kg_ha
      end
    end

    context 'the transaction involves seeds ' do
      it 'gets the right rate when provided with seeds per acre' do
        @transaction.rate = 30000
        material = find_or_factory(:material, name: 'seed')
        unit = find_or_factory(:unit, name: "seeds")
        @transaction.material = material
        @transaction.unit = unit
        expect(@transaction.seeds_per_square_meter).to eq 7.41
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
