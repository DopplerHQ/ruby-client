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
  @@api_key = ENV["DOPPLER_API_KEY"]
  def self.api_key=(api_key)
    @@api_key = api_key
  end
  def self.api_key
    @@api_key
  end

  # configure pipeline
  @@pipeline = ENV["DOPPLER_PIPELINE"]
  def self.pipeline=(pipeline)
    @@pipeline = pipeline
  end
  def self.pipeline
    @@pipeline
  end

  # configure environment
  @@environment = ENV["DOPPLER_ENVIRONMENT"]
  def self.environment=(environment)
    @@environment = environment
  end
  def self.environment
    @@environment
  end

  # configure ignore variables
  @@ignore_variables = []
  def self.ignore_variables=(ignore_variables)
    @@ignore_variables = ignore_variables
  end
  def self.ignore_variables
    @@ignore_variables
  end
  
  # configure backup file
  @@backup_filepath = nil
  def self.backup_filepath=(backup_filepath)
    @@backup_filepath = backup_filepath
  end
  def self.backup_filepath
    @@backup_filepath
  end

  # helper to configure above variables.
  def self.configure
    yield(self)
  end
  
end
