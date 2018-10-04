$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "doppler/client"
require "minitest/autorun"

ENV['TESTER'] = "4567"

doppler = Doppler::Client.new(
  api_key = "RbZ7vIrfbOkZF6hDMKDDdhVoYA0AzBqL8An9OAOL",
  pipeline = "31",
  environment = "development_ruby",
  priority = Doppler::Priority.remote,
  send_local_keys = true,
  ignore_keys = []
)

print(doppler.get("HELLO_WORLD") + "\n")
print(doppler.get("TESTER") + "\n")
print(doppler.get("MISSING_KEY"))