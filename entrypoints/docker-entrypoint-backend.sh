#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Setting database..."
bundle exec rake db:create db:migrate DISABLE_DATABASE_ENVIRONMENT_CHECK=1
echo "Finish setting database..."

# echo "Importing development data..."
# psql -h postgresql -U postgres value-list_development < sql_dump/development_data.sql
# echo "Finish importing development data..."

./bin/webpack-dev-server &

echo "Starting Rails server..."
bundle exec rails s -b 0.0.0.0
