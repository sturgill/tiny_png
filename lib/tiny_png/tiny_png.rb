require 'base64'
require 'httparty'
require File.join File.dirname(__FILE__), 'exceptions'
require File.join File.dirname(__FILE__), 'exception_handling'

module TinyPng
  class Shrink
    include TinyPng::ExceptionHandling
    
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
    # Returns: TinyPng::Shrink instance
    #
    def initialize api_key, options={}
      @options = { :suppress_exceptions => false }.merge options
      @auth = { :username => 'api', :password => api_key }
    end
    
    #
    # Replace an image at a given path with its shrunken version
    #
    # The image at the given path will be submitted to TinyPNG and the new version will overwrite the original.  If this process fails for any reason, the original file will be rolled back.
    #
    # Arguments:
    # - image_path (String)
    #   The full path to the image that should be shrunk. Requirements:
    #   - Must be the full and absolute path (not a relative path)
    #   - Path must end in `.png`
    #   - Path must be readable
    #   - Path must be writeable
    #
    # Returns: Boolean (whether or not the action was successful)
    #
    def shrink image_path
      # check to make sure everything looks kosher before sending data to TinyPNG
      return raise_exception InvalidFileType, 'The file must be a PNG' unless image_path.downcase.match(/\.png$/)
      return raise_exception FileDoesntExist, "Can't find a file at the specified path" unless File.exists? image_path
      return raise_exception FileNotReadable, "Can't read the requested file" unless File.readable? image_path
      return raise_exception FileNotWriteable, "Can't write to the specifed file" unless File.writable? image_path
      
      # store current content in case we need to rollback later
      current_content = File.read image_path
      
      # passes our quick checks, so let's fire off the request
      response = self.class.post('/api/shrink', :basic_auth => @auth, :body => current_content.force_encoding('BINARY'))
      
      # abort unless TinyPNG successfully did its thing
      return raise_exception ShrinkingFailed, response.message unless response.code == 200
      
      # only overwrite if the new file is smaller than the old
      if response['output']['ratio'] < 1
        begin
          open(image_path, 'wb') { |f| f.write HTTParty.get(response['output']['url']).parsed_response }
        rescue # if the writing process fails for whatever reason, rollback and raise custom error
          open(image_path, 'wb') { |f| f.write current_content }
          return raise_exception ShrinkingFailed, "Couldn't write new content"
        end
      end
      
      true
    end
  end
end