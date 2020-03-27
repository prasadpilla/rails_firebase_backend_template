set :stage, :qa01
set :rails_env, :production
set :log_level, :debug
server '', user: 'deploy', roles: %w{app db web}
set :sidekiq_processes, 1
