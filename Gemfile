source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'
 
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem 'authlogic', :git => "git://github.com/binarylogic/authlogic.git"
gem "authlogic-oid", :require => 'authlogic_openid'
gem 'rack-openid'
gem 'ruby-openid', :require => 'openid'
gem 'will_paginate'
gem 'thin'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"

group :development do
  gem 'metric_fu'
end

group :test do
  gem "factory_girl"
  gem 'shoulda'
end
