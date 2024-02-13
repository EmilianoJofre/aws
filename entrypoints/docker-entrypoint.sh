#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Setting Webpacker..."
bundle exec rake webpacker:compile
echo "Finish setting Webpacker..."

echo "Setting database..."
bundle exec rails db:migrate:with_data
echo "Finish setting database..."

# echo "Importing development data..."
# psql -h postgresql -U postgres value-list_development < sql_dump/development_data.sql
# echo "Finish importing development data..."

echo "Starting Sidekiq..."
bundle exec sidekiq &

echo "Starting Rails server..."
bundle exec rails s -b 0.0.0.0 -p $PORT