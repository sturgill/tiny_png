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
    def initialize api_key, options={}
      @options = { :suppress_exceptions => false }.merge options
      @auth = { :username => 'api', :password => api_key }
    end
  end
end