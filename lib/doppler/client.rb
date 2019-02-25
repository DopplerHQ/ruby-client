require 'net/https'
require 'json'
require 'doppler/version'

module Doppler
  class Client
    MAX_RETRIES = 10
    ENVIRONMENT_SEGMENT = '/environments/'

    def initialize()
      if Doppler.api_key.nil?
        raise "Please provide a api key"
      end
      
      if Doppler.pipeline.nil?
        raise "Please provide a pipeline"
      end
      
      
      if Doppler.environment.nil?
        raise "Please provide a environment"
      end
         
      startup()
    end

    def startup
      resp = self._request('/fetch_keys', {})
      @remote_keys = resp.fetch("keys")
      
      overwrite_env()
      write_to_backup()
    end
    
    
    def overwrite_env      
      if @remote_keys.nil? 
        return
      end
      
      @remote_keys.each do |key, value|        
        unless Doppler.ignore_variables.include?(key)
          ENV[key] = value
        end
      end
    end
    
    
    def write_to_backup
      unless Doppler.backup_filepath.nil?
        file = File.open(Doppler.backup_filepath, "w")
        
        @remote_keys.each do |key, value|
          file.puts key + "=" + value
        end
        
        file.close
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
          if Doppler.backup_filepath.nil? or !File.file?(Doppler.backup_filepath)
            raise e
          end
          
          keys = {}
          File.open(Doppler.backup_filepath, "r") do |file|
            file.each do |line| 
              parts = line.strip!.split("=")
              
              if parts.length == 2
                keys[parts[0]] = parts[1]
              end
            end
          end
          
          data = {}
          data["keys"] = keys
          return data
          
        else
          return _request(endpoint, body, retry_count)
        end
      end

      return response_data
    end
  end
end
