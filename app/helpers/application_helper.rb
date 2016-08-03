# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # def link_to_remove_fields(name, f)
  #   f.hidden_field(:_destroy) + link_to(name, "remove_fields(this)")
  # end

  def link_to_add_fields(name, f, association, only_current)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, only_current: only_current)
    end
    link_to(name, '#', class: "add_fields", data: { id: id, fields: fields.gsub("\n", "") })
  end

  # def link_to_add_fields(name, f, association, only_current = nil)
  #   new_object = f.object.class.reflect_on_association(association).klass.new
  #   fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
  #     render(association.to_s.singularize + "_fields", :f => builder, :only_current => only_current)
  #   end
  #   link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  # end

  # https://gist.github.com/1205828
  # Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ViewHelpers::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, rel: rel_value(page)), class: ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), class: 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), class: [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  def page_navigation_links(pages)
    will_paginate(pages,
                  class: 'pagination',
                  inner_window: 2,
                  outer_window: 0,
                  renderer: BootstrapLinkRenderer,
                  previous_label: '&larr;'.html_safe,
                  next_label: '&rarr;'.html_safe)
  end
end

