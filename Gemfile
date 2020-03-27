source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.1'
gem 'rack', github: 'rack/rack', branch: 'master'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
gem 'will_paginate', '~> 3.1.0'
gem 'geokit-rails', '>= 2.3.1'
gem 'active_model_serializers', '~> 0.10.10'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Communication
gem 'fcm'
gem "aws-ses", "~> 0.6.0", :require => 'aws/ses'
gem 'msg91ruby'

# Image upload
gem 'carrierwave-base64'
gem 'mini_magick'
gem 'carrierwave-aws'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'devise', '~> 4.7', '>= 4.7.1'
gem "audited", "~> 4.9"

# Monitoring and error reporting
gem 'appsignal'

# Creds management
gem 'figaro'

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'custom_error_message', git: 'https://github.com/thethanghn/custom-err-msg.git'
gem 'rqrcode'


# Logging
gem 'lograge', '>= 0.11.2'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.6.2'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Better Errors replaces the standard Rails error page with a much better and more useful error page
  gem 'better_errors', '~> 2.4'
  # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.
  gem 'binding_of_caller', '~> 0.8.0'
  # Profiling toolkit for Rack applications with Rails integration. Client Side profiling, DB profiling and Server profiling.
  gem 'rack-mini-profiler', '~> 1.0', require: false
  # When mail is sent from your application, Letter Opener will open a preview in the browser instead of sending.
  gem 'letter_opener', '~> 1.6'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-figaro-yml', '~> 1.0.2'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.1'
  gem "factory_bot_rails", ">= 5.0.1"
  gem 'simplecov', require: false
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git'
  gem 'webmock'
  gem 'timecop'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
