# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 6.0'

gem 'pg'

gem 'devise'

gem 'textacular' # , git: 'https://github.com/textacular/textacular.git'

gem 'carrierwave' # , git: 'https://github.com/carrierwaveuploader/carrierwave.git'
gem 'fog-aws'

gem 'will_paginate-bootstrap'

gem 'chronic'

gem "webpacker"

gem 'dotenv-rails'
gem 'simple_form'

gem 'awesome_nested_set' # , git: 'https://github.com/collectiveidea/awesome_nested_set.git'

gem 'jbuilder'

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
  gem 'rbnacl'
  gem 'rbnacl-libsodium'
  gem 'sqlite3'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'listen'
  gem 'rails-controller-testing'
  gem 'rspec-core', git: 'https://github.com/rspec/rspec-core'
  gem 'rspec-expectations', git: 'https://github.com/rspec/rspec-expectations'
  gem 'rspec-its', git: 'https://github.com/rspec/rspec-its'
  gem 'rspec-mocks', git: 'https://github.com/rspec/rspec-mocks'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails'
  gem 'rspec-support', git: 'https://github.com/rspec/rspec-support'
  gem 'shoulda'
end
