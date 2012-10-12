module TinyPng::Shrink
  #
  # Replace an image at a given path with its shrunken version
  #
  # The image at the given path will be submitted to TinyPNG and the new version will overwrite the original.
  # If this process fails for any reason, the original file will be rolled back.
  #
  # Arguments:
  # - shrinkwrap (any number of objects to be shrunk)
  #   You can pass in a directory, or individual files that should be shrunk.  All should be absolute paths.
  #
  #   If you send in a path to a specific file, it must end in `.png` or it will not be sent to TinyPNG for processing.
  #
  #   Likewise, when traversing through a directory, only files that end in `.png` will be examined.
  #
  #   All paths to specific files (whether sent in directly or picked out from the directory) need to be readable and writeable.
  #
  # Returns: Hash { :success => [Array, Of, Paths, Successfully, Overwrittern], :failure => [Array, Of, Paths, Left, Unchanged] }
  #
  
  def shrink *paths
    results = { :success => [], :failure => [] }
    TinyPng::Path.get_all(paths).each do |path|
      key = shrink_in_place(path) ? :success : :failure
      results[key].push path
    end
    results
  end
  
  protected
  
  def shrink_in_place image_path
    # check to make sure everything looks kosher before sending data to TinyPNG
    return raise_exception FileDoesntExist, "Can't find a file at the specified path" unless File.exists? image_path
    return raise_exception FileNotReadable, "Can't read the requested file" unless File.readable? image_path
    return raise_exception FileNotWriteable, "Can't write to the specifed file" unless File.writable? image_path
    
    # store current content in case we need to rollback later
    current_content = File.read image_path
    
    # passes our quick checks, so let's fire off the request
    response = self.class.post(
      '/api/shrink',
      :basic_auth => { :username => @options[:api_user], :password => @options[:api_key] },
      :body => current_content.force_encoding('BINARY')
    )
    
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