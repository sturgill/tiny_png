require 'base64'
require 'httparty'
require File.join File.dirname(__FILE__), 'exceptions'
require File.join File.dirname(__FILE__), 'shrink'
require File.join File.dirname(__FILE__), 'exception_handling'

module TinyPng
  class Client
    include TinyPng::ExceptionHandling
    include TinyPng::Shrink
    
    include HTTParty
    base_uri 'api.tinypng.org'
    
    #
    # Create a new instance of the TinyPng::Shrink class
    #
    # Arguments:
    # - api_key (String)
    # - options (Hash)
    #   - :suppress_exceptions (Boolean)
    #     Default: false
    #     If false (the default), exceptions will be raised when the process fails.  If suppression is turned on, exceptions will not be raised, but a false value will be returned if shrinking fails for any reason.
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
        :username => config['api_user'] || 'api'
      }.merge(options)
    end
  end
end