require 'rails_helper'

describe MaterialType do
  it {is_expected.to have_many(:materials) }
end
