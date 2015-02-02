# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'hbx_documents'
set :repo_url, 'git@github.com:dchbx/hbx_documents.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/deployments/hbx_documents'

# Default value for :scm is :git
# set :scm, :git
# set :scm, :gitcopy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug
set :bundle_binstubs, false
set :bundle_flags, "--quiet"
set :bundle_path, nil

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, (fetch(:linked_files, []) | ['config/database.rb', 'config/exchange.yml'])

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
    task :restart do
      on roles(:app), in: :sequence, wait: 20 do
        sudo "service unicorn_hbx_documents restart"
        sudo "service bluepill_hbx_documents restart"
      end
    end

    after :publishing, :restart


    after :restart, :clear_cache do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
      end
    end

end
