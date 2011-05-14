require 'spec_helper'

describe ObservationsHelper do
  describe "#initialize_arrays" do
    it "should give the right results" do
      js_stuff = "<script type=\"text/javascript\">\n//<![CDATA[\narrayActivityIndexes = []; arraySetupIndexes=[];\n//]]>\n</script>"
      helper.initialize_arrays.should eq(js_stuff)
    end
  end

  describe "#observation_type_ids" do
    it "should give an array of observation types" do
      correct_ones = [["Default", 1], ["Soil Preparation", 2], ["Harvest", 3], ["Planting", 4], ["Fertilizer application", 5], ["Pesticide application", 6], ["Herbicide application", 7]]
      helper.observation_type_ids.should eq(correct_ones)
    end
  end

  describe "#format_cell" do
    it "should return '_' if given an empty array" do
      helper.format_cell([]).should eq('_')
    end

    it "should return the elements formatted for csv" do
      helper.format_cell(['bird', 'plane', 'superman']).should eq('bird;;plane;;superman')
    end
  end
end
