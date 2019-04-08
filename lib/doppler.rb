require 'doppler/client'

module Doppler
  # configure doppler host url
  @@host_url = "https://deploy.doppler.com"
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
  
  # configure env file
  @@env_filepath = ".env"
  def self.env_filepath=(env_filepath)
    @@env_filepath = env_filepath
  end
  def self.env_filepath
    @@env_filepath
  end
  
  # read env file
  def self.read_env(path)
    if path.nil? or !File.file?(path)
      return nil
    end
    
    keys = {}
    File.open(path, "r") do |file|
      file.each do |line|
        parts = line.strip.split("=")
        
        if parts.length == 2
          keys[parts[0].strip] = parts[1].strip
        end
      end
    end
    
    return keys
  end

  # helper to configure above variables.
  def self.configure
    yield(self)
    
    env_file = self.read_env(self.env_filepath) || {}
    self.api_key = self.api_key || env_file["DOPPLER_API_KEY"]
    self.pipeline = self.pipeline || env_file["DOPPLER_PIPELINE"]
    self.environment = self.environment || env_file["DOPPLER_ENVIRONMENT"]
  end
  
end
