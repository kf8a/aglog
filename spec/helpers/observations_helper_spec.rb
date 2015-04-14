require 'spec_helper'

describe ObservationsHelper, type: :helper do
  describe "#initialize_arrays" do
    it "should give the right results" do
      js_stuff = "<script>\n//<![CDATA[\narrayActivityIndexes = []; arraySetupIndexes=[];\n//]]>\n</script>"
      expect(helper.initialize_arrays).to eq(js_stuff)
    end
  end

  describe "#observation_type_ids" do
    it "should give an array of observation types" do
      correct_ones = [["Soil Preparation", 1], ["Harvest", 2], ["Planting", 3], ["Fertilizer application", 4], ["Pesticide application", 5], ["Herbicide application", 6]]
      expect(helper.observation_type_ids).to eq(correct_ones)
    end
  end

  describe "#format_cell" do
    it "should return '_' if given an empty array" do
      expect(helper.format_cell([])).to eq('_')
    end

    it "should return the elements formatted for csv" do
      expect(helper.format_cell(['bird', 'plane', 'superman'])).to eq('bird;;plane;;superman')
    end
  end
end
