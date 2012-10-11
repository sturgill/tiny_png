$LOAD_PATH.unshift 'lib'
require 'tiny_png/version'

Gem::Specification.new do |s|
  s.name = 'tiny_png'
  s.version = TinyPng::Version
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = 'tiny_png'
  s.summary = 'Make your PNGs tiny'
  s.description = "Use the TinyPNG service to minimize the size of your image files."
  s.author = 'Chris Sturgill'
  s.email = 'chris@thesturgills.com'
  s.files = `git ls-files`.split($/)
  s.homepage = 'https://github.com/sturgill/tiny_png'
  s.require_paths = ['lib']
  s.add_dependency 'httparty'
  s.license = 'MIT'
  s.post_install_message = %q{For easiest use, create a config file at config/tiny_png.yml file.  Example:
    https://github.com/sturgill/tiny_png/sample_config.yml
    
  }
end