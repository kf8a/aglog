# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 5.2'

gem 'pg'

gem 'devise'

gem 'haml'

gem 'textacular', git: 'https://github.com/textacular/textacular.git'

gem 'carrierwave', git: 'https://github.com/carrierwaveuploader/carrierwave.git'
# gem 'fog'
gem 'fog-aws'

gem 'will_paginate-bootstrap'

gem 'chronic'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'dotenv-rails'
gem 'simple_form'

gem 'awesome_nested_set', git: 'https://github.com/collectiveidea/awesome_nested_set.git'

gem 'cancan'

gem 'seedbed'

gem 'barista'

gem 'jbuilder'

gem 'coffee-rails'
gem 'therubyracer', require: 'v8'
gem 'uglifier'

gem 'prometheus-client' # , '~> 0.6.0'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'ed25519'
  gem 'rbnacl' , '< 5.0'
  gem 'rbnacl-libsodium'
end

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'single_test'
end
