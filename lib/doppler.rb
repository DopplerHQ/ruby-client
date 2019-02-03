require 'doppler/client'

module Doppler
  # configure doppler host url
  @@host_url = "https://api.doppler.com"
  def self.host_url=(host)
    @@host_url = host_url
  end
  def self.host_url
    @@host_url
  end

  # configure api key
  @@api_key = "sample-api-key"
  def self.api_key=(api_key)
    @@api_key = api_key
  end
  def self.api_key
    @@api_key
  end

  # configure pipeline
  @@pipeline = "sample-pipeline"
  def self.pipeline=(pipeline)
    @@pipeline = pipeline
  end
  def self.pipeline
    @@pipeline
  end

  # configure environment
  @@environment = "development_ruby"
  def self.environment=(environment)
    @@environment = environment
  end
  def self.environment
    @@environment
  end

  # configure priority
  PRIORITY_REMOTE = 0
  PRIORITY_LOCAL = 1
  @@priority = PRIORITY_REMOTE
  def self.priority=(priority)
    @@priority = priority
  end
  def self.priority
    @@priority
  end

  # configure track keys
  @@track_keys = []
  def self.track_keys=(track_keys)
    @@track_keys = track_keys
  end
  def self.track_keys
    @@track_keys
  end

  # configure ignore keys
  @@ignore_keys = []
  def self.ignore_keys=(ignore_keys)
    @@ignore_keys = ignore_keys
  end
  def self.ignore_keys
    @@ignore_keys
  end

  # configure service to be mocked so that no screenshots are
  # taken, and uploaded to service.
  @@enable_service = false
  def self.enable_service=(enable)
    @@enable_service = enable
  end
  def self.enable_service
    @@enable_service
  end

  # configure logger, which will be used to log issues if any
  @@logger = Logger.new(STDOUT)
  def self.logger=(new_logger)
    @@logger = new_logger
  end
  def self.logger
    @@logger
  end

  # helper to configure above variables.
  def self.configure
    yield(self)
  end
end
