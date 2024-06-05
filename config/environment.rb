# Load the Rails application.
require_relative 'application'

Rails.application.configure do
    config.hosts << "awseb--AWSEB-1gsASCn7krdl-53641557.us-east-1.elb.amazonaws.com"
    config.hosts << "awseb--awseb-76fthvt1pu7l-703780421.us-east-1.elb.amazonaws.com"
  end

# Initialize the Rails application.
Rails.application.initialize!
