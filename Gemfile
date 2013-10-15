source 'http://rubygems.org'

gem 'rails', '~> 3.2'

gem 'rake'

gem 'pg'


gem 'devise'

gem 'will_paginate' #, "~> 3.0.pre2"
gem 'will_paginate-bootstrap'
gem 'haml'

gem 'chronic'

#Uses jquery instead of prototype in rails
gem 'jquery-rails' #, '>= 0.2.6'
gem 'jquery-ui-rails'

gem 'formtastic'

gem 'delocalize'

gem 'awesome_nested_set'

gem 'cancan'

gem 'seedbed'

gem 'barista'

gem 'jbuilder'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', :require => 'v8'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'twitter-bootstrap-rails'
  gem 'angularjs-rails',  "~> 1.2.0.rc2"
end

group :production do
  gem 'thin'
end

group :development, :test do
  #gem 'silent-postgres'
  gem 'rspec-rails'
  #gem 'sqlite3-ruby'
  gem 'sqlite3'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'single_test'
  gem 'cucumber-rails', :require => false
  gem 'launchy'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'evergreen', :require => 'evergreen/rails'
end
