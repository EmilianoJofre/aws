require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

module ValueList
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/public/*', headers: :any, methods: :get
        resource '/api/*',
          headers: :any,
          expose: ['X-Page', 'X-PageTotal', 'Authorization'],
          methods: [:get, :post, :patch, :put, :delete, :options]
      end
    end

    config.i18n.fallbacks = [:es, :en]
    config.i18n.default_locale = 'es-CL'
    config.active_job.queue_adapter = :sidekiq
    config.assets.paths << Rails.root.join('node_modules')
    config.load_defaults 6.0

    # Redis configuration with connection pool
    config.cache_store = :redis_cache_store, {
      url: Rails.application.config_for(:redis).cache_url,
      pool_size: ENV.fetch('RAILS_MAX_THREADS') { 20 },
      pool_timeout: 5
    }
  end
end
