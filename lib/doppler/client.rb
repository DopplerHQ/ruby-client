require "doppler/client/version"
require 'net/https'
require 'json'

module Doppler
  class Priority
    @@local = 0
    def self.local
        @@local
    end

    @@remote = 1
    def self.remote
        @@remote
    end
  end

  class Client
    @@host_key = 'DOPPLER_HOST'
    @@default_host = 'https://api.doppler.market'
    @@environ_segment = '/environments/'
    @@max_retries = 0

    def initialize(api_key, pipeline, environment, priority = Priority.remote)
        raise ArgumentError, 'api_key not string' unless api_key.is_a? String
        raise ArgumentError, 'pipeline not string' unless pipeline.is_a? String
        raise ArgumentError, 'api_key not string' unless environment.is_a? String
        raise ArgumentError, 'api_key not numeric' unless priority.is_a? Numeric 

        @api_key = api_key
        @pipeline = pipeline
        @environment = environment
        @default_priority = priority
        @host = ENV[@@host_key] ? ENV[@@host_key] : @@default_host
        
        startup()
    end

    def startup
        resp = self._request('/fetch_keys', {
            'local_keys' => ENV.to_hash
        })

        @remote_keys = resp['keys']
    end

    def get(key_name, priority = nil)
        priority = priority != nil ? priority : @default_priority

        if @remote_keys.key?(key_name)
            if priority == Priority.local
                return ENV[key_name] ? ENV[key_name] : @remote_keys[key_name]
            else
                return @remote_keys[key_name]
            end
        end

        _request('/missing_key', {
            'key_name' => key_name
        })

        return ENV[key_name]
    end

    def _request(endpoint, body, retry_count=0)
        raise ArgumentError, 'endpoint not string' unless endpoint.is_a? String

        raw_url = @host + @@environ_segment + @environment + endpoint
        uri = URI.parse(raw_url)
        header = {
            'Content-Type': 'application/json',
            'api-key': @api_key,
            'pipeline': @pipeline

        }
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        begin
            response = http.post(uri.path, body.to_json, header)
            response_data = JSON.parse(response.body)
            if response_data['success'] == false
                raise RuntimeError, response_data["messages"].join(". ")
            end
        rescue => e
            retry_count += 1

            if retry_count > @@max_retries
                raise e
            else
                return _request(endpoint, body, retry_count)
            end
        end

       return response_data
    end
  end
end
