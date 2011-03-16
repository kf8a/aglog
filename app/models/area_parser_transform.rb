# This class tranforms the area parse tree into where statements for the
# area model

class AreaParserTransform < Parslet::Transform
  #transform plots
  rule(:treatment => simple(:trt), 
       :replicate => simple(:rep)) { String(trt) + 'R'+ String(rep) }
  rule(:study => simple(:study), 
       :plot => simple(:plot)) { {:study => study, :plot => String(study) + plot } }

  # transform ranges
  rule(:treatment => simple(:trt_start), :treatment_end => simple(:trt_end)) {Integer(trt_start)..Integer(trt_end)}
  rule(:treatment => simple(:trt)) {Integer(trt)}
  rule(:replicate => simple(:rep)) {Integer(rep)}
end
