# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def make_request_query(strings)
		if strings.nil? || strings.size == 0
			result = nil
		else
			result = '?'
			strings.each do |s|
				result << s.gsub(/ /, '+') + "&"
			end
			result.chomp("&")
		end # else
	end
  
  def  set_hazard_ids
    @hazard_ids =  Hazard.find(:all).collect {|x| [x.name, x.id]}
  end

# http://woss.name/2006/11/25/multi-select-boxes-in-your-rails-view/

  def collection_select_multiple(object, method,
                                 collection, value_method, text_method,
                                 options = {}, html_options = {})
    real_method = "#{method.to_s.singularize}_ids".to_sym
    collection_select(
      object, real_method,
      collection, value_method, text_method,
      options,
      html_options.merge({
        :multiple => true,
        :name => "#{object}[#{real_method}][]"
      })
    )
  end

  def collection_select_multiple_categories(object, method,
                                            options = {}, html_options = {})
    collection_select_multiple(
      object, method,
      Category.find(:all), :id, :title,
      options, html_options
    )
  end
# /

end
