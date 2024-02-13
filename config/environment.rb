# Load the Rails application.
require_relative 'application'

Rails.application.configure do
    config.hosts << "valuelist-docker-compose-env.eba-zwte3gsd.us-east-1.elasticbeanstalk.com"
  end

# Initialize the Rails application.
Rails.application.initialize!
