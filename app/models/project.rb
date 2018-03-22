# frozen_string_literal: true

# A project is a group that can edit each others
# entries
class Project < ActiveRecord::Base
  has_many :collaborations
end
