# a class to parse the area expressions that might be entered 

class AreaParser < Parslet::Parser
  rule(:range_op)   { space? >> str('-') >> space? }

  rule(:range)      { range_op >> integer.as(:treatment_end) }
  rule(:range?)     { range.maybe }

  rule(:wildcard)   { str('*') }

  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }
  rule(:comma)      { str(',') }

  rule(:delimiter)  { space? >> comma >> space? | space }
  rule(:delimiter?) { delimiter.maybe }

  rule(:study)      { match('[A-Z]').repeat(1) }
  rule(:integer)    { match('\d').repeat(1) }

  rule(:replicate_delimiter) {str('R')}

  rule(:treatment_number) { integer | wildcard }
  rule(:replicate_number) { integer | wildcard }

  rule(:trt_rep)    { treatment_number.as(:treatment) >>
                      replicate_delimiter >> replicate_number.as(:replicate) }

  rule(:trt)        { treatment_number.as(:treatment) }

  rule(:single_plot){ trt_rep }
  rule(:plot_range) { trt >> range | trt }
  rule(:plot)       { single_plot.as(:plot) | plot_range.as(:plot_range) }
  rule(:area)       { study.as(:study) >> plot }

  rule(:areas)      { area >> delimiter? }
  rule(:expression) { areas.repeat(1) }
  root(:expression)
end
