# a class to parse the area expressions that might be entered 

class AreaParser < Parslet::Parser
  rule(:range_op)   { space? >> str('-') >> space? }

  rule(:range)      { range_op >> integer.as(:treatment_end) }

  rule(:wildcard)   { str('*') }

  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }
  rule(:comma)      { str(',') }

  rule(:delimiter)  { space? >> comma >> space? | space }
  rule(:delimiter?) { delimiter.maybe }

  rule(:study)      { match('\b[A-Z]|[a-z]').repeat(1) }
  rule(:integer)    { match('\d').repeat(1,2) }
  rule(:irregular_plot) { match('\d').repeat(3) }

  rule(:rep)        { wildcard >> str('R') >> 
                      integer.as(:replicate) }

  rule(:trt_rep)    { integer.as(:treatment) >>
                      str('R') >> integer.as(:replicate) }

  rule(:trt)        { integer.as(:treatment) }

  rule(:single_plot){ irregular_plot | trt_rep }
  rule(:trt_range)  { trt >> range | trt }
  rule(:plot)       { single_plot.as(:name) | trt_range.as(:treatment_number) | rep.as(:replicate_number)}
  rule(:plot?)      { plot.maybe }

  rule(:area)       { study.as(:study) >> plot? } 
  rule(:areas)      { area >> delimiter? }

  rule(:expression) { areas.repeat(1) }
  root(:expression)
end
