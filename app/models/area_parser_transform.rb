# This class tranforms the area parse tree into where statements for the
# area model

class AreaParserTransform < Parslet::Transform
  #transform plots
  rule(:treatment => simple(:trt), 
       :replicate => simple(:rep)) { String(trt) + 'R'+ String(rep) }
  rule(:study => simple(:study), 
       :name=> simple(:plot)) { {:study => String(study), :name=> String(study) + plot} }

  # transform ranges
  rule(:treatment => simple(:trt_start), :treatment_end => simple(:trt_end)) {Integer(trt_start)..Integer(trt_end)}
  rule(:treatment => simple(:trt)) {Integer(trt)}
  rule(:replicate => simple(:rep)) {Integer(rep)}
  rule(:study => simple(:study), 
       :treatment_number => simple(:trt)) { {:study => String(study), :treatment_number => trt } }
  rule(:study => simple(:study),
      :replicate_number => simple(:rep)) { {:study => String(study), :replicate_number => rep } }
  rule(:study => simple(:study)) { { :study => String(study)} }
end
