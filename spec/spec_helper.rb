# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

def find_or_factory(model, attributes = {})
  model_as_constant = model.to_s.titleize.delete(' ').constantize
  object = model_as_constant.where(attributes).first
  object ||= FactoryBot.create(model.to_sym, attributes)
  object
end

def sign_in_as_normal_user(company_name = 'lter')
  # company = find_or_factory(:company, name: company_name)
  # person = Person.first_or_create
  user = FactoryBot.create(:user) # member.save!
  sign_in user
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.order = 'random'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    with.library :rails
  end
end

class PersonSessionsController # override new in PersonSessionsController for easier testing
  def new
    person = Person.first
    self.current_user = person
    redirect_back_or_default '/observations'
  end
end
