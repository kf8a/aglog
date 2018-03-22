# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 4.2.8'

gem 'pg', '~> 0.2'

gem 'devise', '~> 4.1.0'

gem 'haml'

gem 'textacular', '~> 3.0'

gem 'carrierwave', git: 'https://github.com/carrierwaveuploader/carrierwave.git'
gem 'fog'

gem 'will_paginate-bootstrap'

gem 'chronic'

# Uses jquery instead of prototype in rails
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'dotenv-rails'
gem 'simple_form'

# gem 'delocalize'

gem 'awesome_nested_set', git: 'https://github.com/collectiveidea/awesome_nested_set.git'

gem 'cancan'

gem 'seedbed'

gem 'barista'

gem 'jbuilder'

gem 'coffee-rails'
gem 'therubyracer', require: 'v8'
gem 'uglifier'

gem 'prometheus-client', '~> 0.6.0'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'rbnacl', '< 5.0'
  gem 'rbnacl-libsodium'
end

group :development, :test do
  gem 'rspec-its'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'evergreen', require: 'evergreen/rails'
  gem 'factory_bot_rails'
  gem 'shoulda'
  gem 'single_test'
end
