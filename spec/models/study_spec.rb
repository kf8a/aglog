require 'rails_helper'

describe Study do
  it {should validate_uniqueness_of :name}

end

