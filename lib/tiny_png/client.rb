require 'base64'
require 'httparty'
require 'tiny_png/exceptions'
require 'tiny_png/shrink'
require 'tiny_png/exception_handling'

module TinyPng
  class Client
    include TinyPng::ExceptionHandling
    include TinyPng::Shrink
    
    include HTTParty
    base_uri 'api.tinypng.org'
    
    #
    # Create a new instance of the TinyPng::Shrink class.  Any key not passed into the
    # options hash will use the corresponding value from config/tiny_png.yml. If the config
    # file does not exist, or if the config file does not define a given value, sensible defaults 
    # (as outlined below) will be used.
    #
    # Arguments:
    # - options (Hash)
    #   - :suppress_exceptions (Boolean)
    #     Default: false
    #     If false (the default), exceptions will be raised when the process fails.  If suppression is 
    #     turned on, exceptions will not be raised, but a false value will be returned if shrinking fails 
    #     for any reason.
    #   - :api_key (String)
    #     Default: ''
    #   - :api_user (String)
    #     Default: 'api'
    #
    # Returns: TinyPng::Client instance
    #
    def initialize options={}
      if defined?(Rails) && Rails.try(:root) && Rails.try(:env)
        config_path = File.join(Rails.root, 'config', 'tiny_png.yml')
        config = YAML.load_file(config_path)[Rails.env] if File.exists? config_path
      end
      config ||= {}
      
      @options = {
        :suppress_exceptions => config['suppress_exceptions'] || false,
        :api_key => config['api_key'] || '',
        :api_user => config['api_user'] || 'api'
      }.merge(options)
    end
  end
end