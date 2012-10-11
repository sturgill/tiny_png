Capistrano::Configuration.instance(:must_exist).load do
  namespace :tiny_png do
    def rails_env
      fetch(:rails_env, 'production')
    end
    
    def roles
      fetch(:tiny_png_server_role, :web)
    end
    
    def shrinkwrap
      fetch(:tiny_png_shrink, current_path)
    end
    
    def rake_env
      env = ["RAILS_ENV=#{rails_env}", "SHRINK=#{shrinkwrap}"]
      env.push "API_KEY=#{self[:tiny_png_api_key]}" unless self[:tiny_png_api_key].nil?
      env.push "API_USER=#{self[:tiny_png_api_user]}" unless self[:tiny_png_api_user].nil?
      env.push "SUPPRESS_EXCEPTIONS=#{self[:tiny_png_suppress_exceptions]}" unless self[:tiny_png_suppress_exceptions].nil?
      env
    end

    def rake(*tasks)
      rake = fetch(:rake, "rake")
      tasks.each do |t|
        run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; if [ -f Rakefile ]; then #{rake} #{rake_env.join(' ')} #{t}; fi;"
      end
    end

    desc "Send the requested images to TinyPNG.org for shrinking"
    task :shrink, :roles => lambda { roles } do
      rake 'tiny_png:shrink'
    end
  end
end