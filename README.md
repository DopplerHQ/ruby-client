# Doppler Ruby Library

[![image](https://img.shields.io/gem/v/doppler-client.svg)](https://rubygems.org/gems/doppler-client)

The Doppler Ruby library provides convenient access to the Doppler API from
applications written for **only** server-side code.

## Installation

Install the gem with:
``` bash
gem install doppler-client
```

## Usage

The package needs to be configured with your account's api key which is available in your [Doppler account](https://doppler.market/workplace/api_key), pipeline identifier and the environment name:

``` ruby
require "doppler-client"

doppler = Doppler::Client.new(
  api_key = ENV["API_KEY"],
  pipeline = ENV["PIPELINE_ID"],
  environment = ENV["ENVIRONMENT_NAME"]
)

# Rest of Application
```

## Key Best Practices

So if Doppler stores my environment keys, where should I keep my Doppler API keys?

That is a great question! We recommend storing your `API_KEY`, `PIPELINE_ID`, and `ENVIRONMENT_NAME` 
in local environment. That means the only keys you should be storing in your local environment are the Doppler keys. All other keys should be be fetched by the Doppler client.


### Fetch Environment Keys

You can fetch your environment keys from Doppler by calling the `get(name)` method.

``` ruby
doppler.get(KEY_NAME)
```

Here is an example:

``` ruby
config = {
  "segment_key" => doppler.get("SEGMENT_API_KEY"),
  "algolia_key" => doppler.get("ALGOLIA_API_KEY")
}

```

If there are differences between the values your local environment sets and the ones on Doppler, the client will use the ones provided by Doppler. You can override this behavior by passing in a second argument to the `get(key_name, priority)` method that sets the priority to favor your local environment.

For example:

``` ruby
# Local Enviroment
os.environ["MAGICAL_KEY"] = "123"

# Doppler
MAGICAL_KEY = "456"


# Default Behavior
doppler.get("MAGICAL_KEY") # => "456"

# Override to Local
doppler.get("MAGICAL_KEY", Doppler::Priority.local) # => "123"
```

You can also set the priority globally on initialization:

``` ruby
doppler = Doppler::Client.new(
  api_key = ENV["API_KEY"],
  pipeline = ENV["PIPELINE_ID"],
  environment = ENV["ENVIRONMENT_NAME"],
  priority = Doppler::Priority.local
)

```

## Local Key Privacy

By default the Doppler client will only track the local environment keys that are used during `doppler.get()`.
Collecting only those local keys helps us automatically setup your pipelines
for immediate use. After setup we also use your keys to detect when your keys locally have
changed from what is on Doppler. We then provide a way for you to adopt or reject those changes
through our dashboard. This can help help when debugging silent bugs or build failures.

### Track Additional Keys
The Doppler client can also track additional keys by providing an array of keys to the `track_keys` field.

``` ruby
doppler = Doppler::Client.new(
  api_key = ENV["API_KEY"],
  pipeline = ENV["PIPELINE_ID"],
  environment = ENV["ENVIRONMENT_NAME"],
  priority = Doppler::Priority.local,
  track_keys = [
    "KEY_TO_TRACK"
  ]
)
```

### Ignoring Specific Keys
Inversely, you can also ignore specific local keys by adding them to the `ignore_keys` array.

``` ruby
doppler = Doppler::Client.new(
  api_key = ENV["API_KEY"],
  pipeline = ENV["PIPELINE_ID"],
  environment = ENV["ENVIRONMENT_NAME"],
  priority = Doppler::Priority.local,
  track_keys = [],
  ignore_keys = [
    "SUPER_SECRET_KEY"
  ]
)
```

## Extra Information

- [Doppler](https://doppler.market)
- [API KEY](https://doppler.market/workplace/api_key)

