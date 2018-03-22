# frozen_string_literal: true

# memberships link people to companies
class Membership < ActiveRecord::Base
  belongs_to :person
  belongs_to :company
end
