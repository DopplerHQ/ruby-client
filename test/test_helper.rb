$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

ENV['DOPPLER_API_KEY'] = "lK1obsC3Q1atBqAw5AoqXmLDXC77eigYqFZOlVz2"
ENV["DOPPLER_PIPELINE"] = "31"
ENV["DOPPLER_ENVIRONMENT"] = "development_ruby"

require "doppler"

Doppler.configure do |config|
  config.override = true;
end

doppler = Doppler::Client.new()

print(doppler.get("TESTER") + "\n")
print(ENV["TESTER"] + "\n")