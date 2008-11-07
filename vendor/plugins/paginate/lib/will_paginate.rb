module WillPaginate
  # PaginatedEntries is a proxy to the real collection of paginated
  # records. It is returned from AR::Base#paginate methods.
  #
  class PaginatedEntries
    include Enumerable

    def each &block
      @entries.each &block
    end

    attr_reader :page, :per_page, :entries
    attr_accessor :total_entries

    def initialize entries, page, per_page, total
      @entries = entries
      @page = page
      @per_page = per_page
      @total_entries = total
      @total_pages = (@total_entries / @per_page.to_f).ceil
    end

    def page_count
      @total_pages
    end

    def to_a
      @entries
    end
    
    # Renders Digg-style pagination.
    # "will_paginate" view helper uses this method.
    #
    def to_html view, options = {}
      @view = view # for UrlHelper

      if @total_pages > 1
        options = options.reverse_merge :class => 'pagination',
          :prev_label   => '&laquo; Previous',
          :next_label   => 'Next &raquo;',
          :inner_offset => 4, # links around the current page
          :outer_offset => 1  # links around beginning and end
        
        inner_offset, outer_offset = options.delete(:inner_offset), options.delete(:outer_offset)
        
        min = @page - inner_offset
        max = @page + inner_offset
        
        # adjust lower or upper limit if other is out of bounds
        if max > @total_pages then min -= max - @total_pages
        elsif min < 1  then max += 1 - min
        end
        
        current   = min..max
        beginning = 1..(1+outer_offset)
        tail      = (@total_pages-outer_offset)..@total_pages
        visible = [current, beginning, tail].map(&:to_a).sum
        
        # build the list of the links
        links = (1..@total_pages).inject([]) do |list, n|
          if visible.include? n
            list << link_or_span(n, n == @page, 'current')
          elsif n == beginning.last + 1 || n == tail.first - 1
            list << '...'
          end
          list
        end
        
        # next and previous buttons
        prev, succ  = page-1, page+1
        links.unshift link_or_span(prev, prev.zero?,          'disabled', options.delete(:prev_label))
        links.push    link_or_span(succ, succ > @total_pages, 'disabled', options.delete(:next_label))
        
        @view.content_tag :div, links.join(' '), options
      else
        nil
      end
    end

    protected

      def link_or_span(target, condition, span_class = nil, text = target.to_s)
        condition ? @view.content_tag(:span, text, :class => span_class) :
          @view.link_to(text, {:page => target}.reverse_merge(@view.params))
      end

      # delegate missing stuff to the collection array
      def method_missing(method, *args, &block)
        @entries.send method, *args, &block
      end
  end

  module ViewHelpers
    def will_paginate entries = @entries, options = {}
      entries.to_html self, options
    end
  end
end
