# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

# The environment variable WEB_CONCURRENCY may be set to a default value based
# on dyno size. To manually configure this value use heroku config:set
# WEB_CONCURRENCY.
#
# Increasing the number of workers will increase the amount of resting memory
# your dynos use. Increasing the number of threads will increase the amount of
# potential bloat added to your dynos when they are responding to heavy
# requests.
#
# Starting with a low number of workers and threads provides adequate
# performance for most applications, even under load, while maintaining a low
# risk of overusing memory.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 10))
threads_count = Integer(ENV.fetch("MAX_THREADS", 10))
threads(threads_count, threads_count)

preload_app!

rackup DefaultRackup
port ENV.fetch('PORT', 3000)
rack_env = ENV.fetch("RACK_ENV", "development")
environment rack_env

# Set 1 day timeout for workers while developing
worker_timeout 24 * 60 * 60 if rack_env == "development"

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

