#!/bin/bash
bundle exec rake db:migrate:with_data
if [ $? -eq 0 ]
then
  bundle exec rails webpacker:compile

  bundle exec rails server -b 0.0.0.0 -p $PORT
else
  echo "Failure: migrations failed, please check application logs for more details." >&2
  exit 1
fi

