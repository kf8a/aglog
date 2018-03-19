source 'https://rubygems.org'

gem 'rails', '~> 4.2.8'

gem 'pg', '~> 0.2'

gem 'devise', '~> 4.1.0'

gem 'textacular', '~> 3.0'

gem 'carrierwave', git: 'https://github.com/carrierwaveuploader/carrierwave.git'
gem 'fog'

gem 'will_paginate-bootstrap'
gem 'haml'

gem 'chronic'

#Uses jquery instead of prototype in rails
gem 'jquery-rails' #, '>= 0.2.6'
gem 'jquery-ui-rails'

gem 'simple_form'
gem 'dotenv-rails'

# gem 'delocalize'

gem 'awesome_nested_set', git: 'https://github.com/collectiveidea/awesome_nested_set.git'

gem 'cancan'

gem 'seedbed'

gem 'barista'

gem 'jbuilder'

gem 'therubyracer', :require => 'v8'
gem 'coffee-rails'
gem 'uglifier'

#gem 'less-rails'

gem 'prometheus-client', '~> 0.6.0'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rails'
  gem 'rbnacl', '< 5.0'
  gem 'rbnacl-libsodium'
  gem 'bcrypt_pbkdf'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
end

group :test do
  gem 'factory_bot_rails'
  gem 'shoulda'
  gem 'single_test'
  gem 'cucumber-rails', :require => false
  gem 'launchy'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'evergreen', :require => 'evergreen/rails'
end
