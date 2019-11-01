# frozen_string_literal: true

lock '3.11.0'

set :application, 'aglog'
set :repo_url, 'https://github.com/kf8a/aglog.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/u/apps/aglog'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w[config/database.yml .env]

# Default value for linked_dirs is []
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'unicorn:restart'
