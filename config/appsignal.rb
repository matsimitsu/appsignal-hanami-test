require "appsignal"

# Setup config
Appsignal.config = Appsignal::Config.new(Hanami.root, Hanami.env)

# Start the logger and the Agent
Appsignal.start_logger
Appsignal.start
