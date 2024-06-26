Rails.application.configure do
  # config.active_job.queue_adapter = :async #Esta configuracion se encuentra actualmente en GCP
  config.action_mailer.delivery_method = :sendgrid_dev
  Rails.application.config.action_mailer.sendgrid_settings = {
    api_key: ENV['SENDGRID_API_KEY']
  }
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  config.active_storage.service = :local
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.hosts << "awseb--awseb-1gsascn7krdl-53641557.us-east-1.elb.amazonaws.com"
end
