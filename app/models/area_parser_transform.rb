class AreaParserTransform < Parslet::Transform
    rule(:treatment => simple(:trt_start), :treatment_end => simple(:trt_end)) {Integer(trt_start)..Integer(trt_end)}
end
