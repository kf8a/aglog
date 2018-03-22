require 'rails_helper'

describe Company do
  it {is_expected.to have_many :equipment}
  it {is_expected.to have_many :areas}
  it {is_expected.to have_many :materials}
  it {is_expected.to have_many :observations}
end
