require 'sidekiq/web'
require 'sidekiq'
require 'sidekiq-status'

REDIS_URL = ENV['REDIS_URL'] || 'redis://localhost:6379/5' 
REDIS_POLLING_INTERVAL = ENV['REDIS_POLLING_INTERVAL'] || 10
REDIS_CLIENT_SIZE = ENV['REDIS_CLIENT_SIZE'] || 3
REDIS_NAMESPACE = ENV['REDIS_NAMESPACE'] || 'floormaps'

Sidekiq.configure_server do |config|
#  config.redis = { url: REDIS_URL, namespace: REDIS_NAMESPACE }
  config.average_scheduled_poll_interval = REDIS_POLLING_INTERVAL
  config.server_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end  
end

Sidekiq.configure_client do |config|
 # config.redis = { url: REDIS_URL, size: REDIS_CLIENT_SIZE, namespace: REDIS_NAMESPACE }
  config.client_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
end

