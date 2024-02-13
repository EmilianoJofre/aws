#!/bin/bash
RAILS_ENV=development bundle exec rake db:migrate:with_data
if [ $? -eq 0 ]
then
  RAILS_ENV=development bundle exec rails server -p $PORT
else
  echo "Failure: migrations failed, please check application logs for more details." >&2
  exit 1
fi

