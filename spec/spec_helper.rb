# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.coverage_dir 'tmp/coverage'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require "#{Rails.root}/db/seeds.rb"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

def find_or_factory(model, attributes = Hash.new)
  model_as_constant = model.to_s.titleize.gsub(' ', '').constantize
  object = model_as_constant.where(attributes).first
  object ||= FactoryGirl.create(model.to_sym, attributes)

  object
end

def sign_in_as_normal_user(company=nil)
  @user = find_or_factory(:person)
  @user.company = company unless company.nil?
  session[:user_id] = @user.id
end

def sign_out
  session[:user_id] = nil
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

class PersonSessionsController

  #override new in PersonSessionsController for easier testing
  def new
    person = Person.first
    self.current_user = person
    redirect_back_or_default '/observations'
  end
end
