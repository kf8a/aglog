class AreaParserTransform < Parslet::Transform
  #transform plots
  rule(:treatment => simple(:trt), :replicate => simple(:rep)) {String(trt) + 'R'+ String(rep)}
  rule(:study => simple(:study), :plot => simple(:plot)) {%Q{where(:study => "#{study}", :plot => "#{study}#{plot}")}}

  # transform ranges
  rule(:treatment => simple(:trt_start), :treatment_end => simple(:trt_end)) {Integer(trt_start)..Integer(trt_end)}
  rule(:treatment => simple(:trt)) {Integer(trt)}
  rule(:study => simple(:study), :plot_range => simple(:range)) { %Q{where(:study => "#{study}", :treatment_number => #{range})}}

end
