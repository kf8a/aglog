module WillPaginate
  module Finder
    def self.included(base)
      base.extend ClassMethods
      class << base
        alias_method_chain :method_missing, :will_paginate
        define_method(:per_page) { 30 } unless respond_to? :per_page
      end
    end
    
    module ClassMethods
      def method_missing_with_will_paginate(method, *args, &block)
        unless method.to_s.index('paginate') == 0
          return method_missing_without_will_paginate(method, *args, &block) 
        end
        options = args.last.is_a?(Hash) ? args.pop.symbolize_keys : {}
        
        page = (options.delete(:page) || 1).to_i
        entries_per_page = options.delete(:per_page) || per_page

        total_entries = unless options[:total_entries]
          count_options = options.slice :conditions, :joins, :include, :group, :select, :distinct
          count_options[:select] = options[:count] if options.key? :count
          count(count_options)
        else
          options.delete(:total_entries)
        end

        [:distinct, :count].each {|key| options.delete key } unless options.empty?
        
        finder = method.to_s.sub /^paginate/, 'find'
        args.push options.merge(:offset => (page - 1) * entries_per_page, :limit => entries_per_page)

        if finder == 'find'
          args.unshift(:all) if args.length < 2
        elsif finder !~ /^find_all/
          finder.sub! /^find/, 'find_all'
        end

        entries = send finder, *args
        PaginatedEntries.new entries, page, entries_per_page, total_entries
      end
    end
  end

  module ControllerHelpers
    # Returns a paginator and a collection of Active Record model instances
    # for the paginator's current page. This should be deprecated in favor of
    # the "paginate" finders on AR models.
    #
    # +options+ are:
    # <tt>:singular_name</tt>:: the singular name to use, if it can't be inferred by singularizing the collection name
    # <tt>:class_name</tt>:: the class name to use, if it can't be inferred by
    #                        camelizing the singular name
    # <tt>:per_page</tt>::   the maximum number of items to include in a 
    #                        single page. Defaults to 10
    # <tt>:conditions</tt>:: optional conditions passed to Model.find(:all, *params) and
    #                        Model.count
    # <tt>:order</tt>::      optional order parameter passed to Model.find(:all, *params)
    # <tt>:joins</tt>::      optional joins parameter passed to Model.find(:all, *params)
    #                        and Model.count
    # <tt>:include</tt>::    optional eager loading parameter passed to Model.find(:all, *params)
    #                        and Model.count
    # <tt>:select</tt>::     :select parameter passed to Model.find(:all, *params)
    #
    # <tt>:count</tt>::      parameter passed as :select option to Model.count(*params)
    #
    def paginate(model, options = {})
      options.symbolize_keys!
      raise ArgumentError, '"join" parameter was removed; please use ":joins"' if options.key? :join
      singular = options.delete :singular_name
      model = (options.delete(:class_name) || (singular || model.to_s.singularize).camelize).constantize

      collection = model.paginate options
      [collection, collection.entries]
    end
  end
end
