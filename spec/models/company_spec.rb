require 'rails_helper'

describe Company do
  it {should have_many :people}
  it {should have_many :equipment}
  it {should have_many :areas}
  it {should have_many :materials}
  it {should have_many :observations}
end
