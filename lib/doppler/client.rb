require 'net/https'
require 'json'
require 'set'
require 'doppler/version'

module Doppler
  class Client
    MAX_RETRIES = 10
    ENVIRONMENT_SEGMENT = '/environments/'

    def initialize()
      startup()
    end

    def startup
      local_keys = ENV.to_hash
      keys_to_send = local_keys.select { |k, _| Doppler.track_keys.include?(k) }

      resp = self._request('/fetch_keys', {
                             'local_keys' => keys_to_send
                           })

      @remote_keys = resp['keys']
    end

    def get(key_name, priority = Doppler.priority)
      value =
        if priority == Doppler::PRIORITY_LOCAL
          ENV[key_name] || @remote_keys[key_name]
        else
          @remote_keys[key_name] || ENV[key_name]
        end

      unless Doppler.ignore_keys.include?(key_name)
        # TODO: Move this to a background job or thread once we get more customers!
        upload_key_to_server(key_name, value)
      end

      value
    end

    def upload_key_to_server(key_name, value)
      if value
        if ENV[key_name] != @remote_keys[key_name]
          _request('/track_key', {
                     'local_keys' => {key_name: ENV[key_name]}
                   })
        end
      else
        _request('/missing_key', {
                   'key_name' => key_name
                 })
      end
    end

    def _request(endpoint, body, retry_count=0)
      raise ArgumentError, 'endpoint not string' unless endpoint.is_a? String

      raw_url = Doppler.host_url + ENVIRONMENT_SEGMENT + Doppler.environment + endpoint
      uri = URI.parse(raw_url)
      header = {
        'Content-Type': 'application/json',
        'api-key': Doppler.api_key,
        'pipeline': Doppler.pipeline,
        'client-sdk': 'ruby',
        'client-version': Doppler::VERSION

      }
      http = ::Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      begin
        response = http.post(uri.path, body.to_json, header)
        response_data = JSON.parse(response.body)
        if response_data['success'] == false
          raise RuntimeError, response_data["messages"].join(". ")
        end
      rescue => e
        retry_count += 1

        if retry_count > MAX_RETRIES
          raise e
        else
          return _request(endpoint, body, retry_count)
        end
      end

      return response_data
    end
  end
end
