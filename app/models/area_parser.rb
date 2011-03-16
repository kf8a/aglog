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

  rule(:study)      { match('[A-Z]|[a-z]').repeat(1) }
  rule(:integer)    { match('\d').repeat(1) }

  rule(:replicate_delimiter) {str('R')}

  rule(:treatment_number) { integer }
  rule(:replicate_number) { integer }

  rule(:rep)        { wildcard >> replicate_delimiter >> 
                      replicate_number.as(:replicate) }

  rule(:trt_rep)    { treatment_number.as(:treatment) >>
                      replicate_delimiter >> replicate_number.as(:replicate) }

  rule(:trt)        { treatment_number.as(:treatment) }

  rule(:single_plot){ trt_rep }
  rule(:trt_range)  { trt >> range | trt }
  rule(:plot)       { single_plot.as(:name) | trt_range.as(:treatment_number) | rep.as(:replicate_number)}
  rule(:plot?)      { plot.maybe }

  rule(:area)       { study.as(:study) >> plot? } 
  rule(:areas)      { area >> delimiter? }

  rule(:expression) { areas.repeat(1) }
  root(:expression)
end
