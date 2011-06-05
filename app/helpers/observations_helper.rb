module ObservationsHelper

  def initialize_arrays
    data = "arrayActivityIndexes = []; arraySetupIndexes=[];"
    javascript_tag(data)
  end

  def observation_type_ids
    @observation_type_ids ||= ObservationType.all.collect do |type|
      [type.name, type.id]
    end
  end

  def format_cell(array)
    if array.empty?
      "_"
    else
      array.join(';;').gsub(/([,])/, ' ')
    end
  end

  def area_help_text
    "Areas separated by commas. For example:<br />
    If you type: <b>G2R3, G3R3</b><br />
    Then you will get both areas G2R3 and G3R3<br />
    If you just type <b>G2</b>, you will get all of the G2 areas<br />
    You can also specify a range: <b>T1-4</b><br />".html_safe
  end

end
