require_relative 'boot'

require 'rails/all'
require_relative '../app/helpers/log_helpers'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApp
  class Application < Rails::Application
    include LogHelpers
    # Initialize configuration defaults for originally generated Rails version.
    config.time_zone = 'Asia/Kolkata'
    config.load_defaults 5.2
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.custom_options = lambda do |event|
      { timestamp: Time.now }
    end

    config.lograge.custom_payload do |controller|
      {client_ip: controller.request.remote_ip, referrer: controller.request.referrer,
       user_id: controller.current_user.try(:id),
       params: obfuscate_sensitive_info(controller.request.request_parameters || controller.request.body.map)}
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += %W( lib )
    config.eager_load_paths += %W( lib )
  end
end
