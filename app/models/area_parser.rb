# a class to parse the area expressions that might be entered 

class AreaParser < Parslet::Parser
  rule(:range_op)   { str('-') >> space?}

  rule(:range)     { range_op >> integer.as(:treatment_end)}
  rule(:range?)    { range.maybe}

  rule(:wildcard)  { str('*') }

  rule(:space)     { match('\s').repeat(1) }
  rule(:space?)    { space.maybe }
  rule(:comma)     {str(',')}

  rule(:delimiter)  { space | space? >> comma >> space? }
  rule(:delimiter?) { delimiter.maybe }

  rule(:study)     { match('[A-Z]').repeat(1) }
  rule(:integer)   { match('\d').repeat(1) }

  rule(:replicate_delimiter) {str('R')}

  rule(:treatment_number) { integer | wildcard }
  rule(:replicate_number) { integer | wildcard }

  rule(:plot)      { study.as(:study) >> treatment_number.as(:treatment) >>
                     replicate_delimiter >> replicate_number.as(:replicate)}

  rule(:treatment) { study.as(:study) >> treatment_number.as(:treatment) }

  rule(:area)      { plot | treatment }

  rule(:area_with_range) {area >> space? >> range? }
  rule(:areas)  { area_with_range >> delimiter? }
  rule(:areas?) { areas.maybe }
  rule(:expression) {areas.repeat(1) }
  root(:expression)
end
