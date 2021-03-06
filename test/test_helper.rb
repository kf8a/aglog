# require 'simplecov'
# SimpleCov.start 'rails'
# SimpleCov.coverage_dir 'tmp/coverage'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_bot'
require 'shoulda'

class ActiveSupport::TestCase #fixtures :all
  # Add more helper methods to be used by all tests here...
  setup :load_data_if_necessary

  protected

  def load_data_if_necessary
    load "#{Rails.root}/db/seeds.rb" if Area.find_by_name('iF9R4').blank?
  end

  def sign_in_as_normal_user
    @user = Person.first || Factory.create(:person)
    session[:user_id] = @user.id
  end

  def sign_out
    session[:user_id] = nil
  end
end

#Shoulda currently has a bug where they use Test::Unit instead of ActiveSupport
unless defined?(Test::Unit::AssertionFailedError)
  class Test::Unit::AssertionFailedError < ActiveSupport::TestCase::Assertion; end
end
