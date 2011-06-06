# from http://groups.google.com/group/rspec/msg/e4ffd3a50adeb4ee
RSpec::Matchers.define :be_json_eql do | expected | 
  match do | actual | 
     @expected = decode(expected, 'expected') 
     @actual = decode(actual, 'actual') 
     @actual == @expected 
  end 
  failure_message_for_should do | actual | 
    difference = @exected.respond_to?('diff') ? @expected.diff(@actual) : @expected - @actual
    "expected\n#{actual}\n" + 
    "to be JSON code equivalent to\n#{@xpected}\n" + 
    "Difference:\n...#{difference.inspect}" 
  end 
  failure_message_for_should_not do | actual | 
    "expected\n#{actual}\n" + 
    "to be JSON code different from\n#{expected}" 
  end 
  def decode(s, which) 
    ActiveSupport::JSON.decode(s) 
    rescue ActiveSupport::JSON::ParseError 
      raise ArgumentError, "Invalid #{which} JSON string: 
    #{s.inspect}" 
  end
end
