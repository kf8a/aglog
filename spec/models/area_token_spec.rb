describe AreaToken do
  it 'puts non-existent areas into invalid_tokesn' do
    _areas, invalid_tokens = AreaToken.tokens_to_areas(%w[T1 T11], 1)
    expect(invalid_tokens[0]).to eq 'T11'
  end

  it 'returns a list of areas' do
    areas, _invalid_tokens = AreaToken.tokens_to_areas(%w[T1 T11], 1)
    expect(areas.size).to eq 6
  end

  it 'returns T1R1 when given T1R1 to parse' do
    area, _invalid = AreaToken.tokens_to_areas(%w[T1R1], 1)
    expect(area[0].name).to eq 'T1R1'
  end

  it "correctly parses 'B31' as a String (there is no B31 area)" do
    _area, invalid = AreaToken.tokens_to_areas(%w[B31], 1)
    expect(invalid[0]).to eq 'B31'
  end
end
