#!/usr/bin/env ruby
require_relative './config/environment'
Dir.glob('app/models/*rb') { |f| require_relative f }
puts 'digraph x {'
Dir.glob('app/models/*rb') do |f|
  f.match(%r{\/([a-z_]+).rb})
  classname = $1.camelize
  klass = Kernel.const_get classname
  if klass.superclass == ActiveRecord::Base
    puts classname
    klass.reflect_on_all_associations.each do |a|
      puts classname + ' -> ' + a.name.to_s.camelize.singularize + ' [label=' + a.macro.to_s + ']'
    end
  end
end
puts '}'
