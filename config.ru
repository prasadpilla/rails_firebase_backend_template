# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler/web'

run Sidekiq::Web

run Rails.application


Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['sidekiq_web_user'], ENV['sidekiq_web_password']]
end