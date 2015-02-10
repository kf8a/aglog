# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'

# require "#{Rails.root}/db/seeds.rb"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

def find_or_factory(model, attributes = Hash.new)
  model_as_constant = model.to_s.titleize.gsub(' ', '').constantize
  object = model_as_constant.where(attributes).first
  object ||= FactoryGirl.create(model.to_sym, attributes)

  object
end

def sign_in_as_normal_user(c=nil)
	company_name = c || 'lter'
  company = find_or_factory(:company, name: company_name)
  @user = find_or_factory(:user, company_id: company.id )
  sign_in @user
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    # mocks.verify_partial_doubles = true
  end
  config.order = "random"

  config.before :each do
    if Capybara.current_driver == :selenium
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # config.include FactoryGirl::Syntax::Methods
end

class PersonSessionsController

  #override new in PersonSessionsController for easier testing
  def new
    person = Person.first
    self.current_user = person
    redirect_back_or_default '/observations'
  end
end
