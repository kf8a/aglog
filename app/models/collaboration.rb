# frozen_string_literal: true

# A collaboration is a link between a user
# and a project used to determine who can edit what
class Collaboration < ActiveRecord::Base
  belongs_to :person
  belongs_to :project
end
