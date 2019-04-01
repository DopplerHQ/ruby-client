require 'net/https'
require 'json'
require 'doppler/version'

module Doppler
  class Client
    MAX_RETRIES = 10

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
      resp = self._request('/v1/variables')
      @remote_keys = resp.fetch("variables")
      
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


    def _request(endpoint, retry_count=0)
      raise ArgumentError, 'endpoint not string' unless endpoint.is_a? String

      uri = URI.parse(Doppler.host_url + endpoint)
      uri.query = URI.encode_www_form({
        'pipeline': Doppler.pipeline,
        'environment': Doppler.environment
      })
      header = {
        'Content-Type': 'application/json',
        'api-key': Doppler.api_key,
        'client-sdk': 'ruby',
        'client-version': Doppler::VERSION
      }

      begin
        request = Net::HTTP::Get.new(uri, header)
        response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
          http.request(request)
        }
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
          data["variables"] = keys
          return data
          
        else
          return _request(endpoint, retry_count)
        end
      end

      return response_data
    end
  end
end
