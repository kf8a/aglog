# This class tranforms the area parse tree into where statements for the
# area model

class AreaParserTransform < Parslet::Transform
  #transform plots
  rule(:treatment => simple(:trt), 
       :replicate => simple(:rep)) { String(trt) + 'R'+ String(rep) }
  rule(:study => simple(:study), 
       :name=> simple(:plot)) { {:where=> ['areas.name = ?', String(study) + plot] } }

  # transform ranges
  rule(:treatment => simple(:trt_start), :treatment_end => simple(:trt_end)) {Integer(trt_start)..Integer(trt_end)}
  rule(:treatment => simple(:trt)) {Integer(trt)}
  rule(:replicate => simple(:rep)) {Integer(rep)}
  rule(:study => simple(:study), 
       :treatment_number => simple(:trt)) { {:where=>['studies.name = ? and treatments.treatment_number in (?)', String(study), trt] } }
  rule(:study => simple(:study),
      :replicate_number => simple(:rep)) { {:where=>['studies.name = ? and replicate = ?', String(study), rep] } }
  rule(:study => simple(:study)) { { :where => ['studies.name = ?', String(study)] } }
end
