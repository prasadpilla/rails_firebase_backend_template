Sidekiq.configure_server do |config|
  config.redis = { url: ENV['cache_server_url'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['cache_server_url'] }
end