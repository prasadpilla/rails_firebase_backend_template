# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'app'
set :repo_url, ''

# Default branch is :master
set :branch, :master

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/app'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/application.yml')
# set :linked_files, fetch(:linked_files, []).push('config/sidekiq.yml')

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.5.1'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :web
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [2, 100]
set :puma_workers, 2
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_roles, [:sidekiq]

namespace :deploy do

  after :deploy, :seed_database do
    on roles(:db), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: fetch(:rails_env, 'production') do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end

before :deploy, "puma:config"
after :deploy, 'sidekiq:restart'