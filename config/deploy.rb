# frozen_string_literal: true

# lock '3.11.2'

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
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/packs node_modules]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 10

after 'deploy:publishing', 'unicorn:restart'

before 'deploy:assets:precompile', 'deploy:yarn_install'
namespace :deploy do
  desc 'Run rake yarn install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end
