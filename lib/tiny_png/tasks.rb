namespace :tiny_png do
  desc 'Shrink the images/directory: the SHRINK env variable must be set (comma-separated list of all files / directories you want shrunk)'
  task :shrink => :environment do
    abort "set SHRINK env var, e.g., $ SHRINK=/path/to/image.png,/path/to/another.png rake tiny_png:shrink" if ENV['SHRINK'].nil?

    options = {}    
    [:api_key, :api_user].each do |key|
      env_key = key.to_s.upcase
      options[key] = ENV[env_key] unless ENV[env_key].nil?
    end
    
    unless ENV['SUPPRESS_EXCEPTIONS'].nil?
      unless ['true', 'false'].include?(ENV['SUPPRESS_EXCEPTIONS'].downcase)
        abort "SUPPRESS_EXCEPTIONS can only be set to true or false: #{ENV['SUPPRESS_EXCEPTIONS']} is not a valid boolean value."
      end
      options[:suppress_exceptions] = ENV['SUPPRESS_EXCEPTIONS'].downcase == 'true'
    end
    
    TinyPng::Client.new(options).shrink ENV['SHRINK'].split(',')
  end
end