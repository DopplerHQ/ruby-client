$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

ENV['DOPPLER_API_KEY'] = "lK1obsC3Q1atBqAw5AoqXmLDXC77eigYqFZOlVz2"
ENV["DOPPLER_PIPELINE"] = "31"
ENV["DOPPLER_ENVIRONMENT"] = "development_ruby"

require "doppler"

Doppler.configure do |config|
  config.backup_filepath = "./backup.env"
end

Doppler::Client.new()

print(ENV["TESTER"])