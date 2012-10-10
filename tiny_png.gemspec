Gem::Specification.new do |s|
  s.name = 'tiny_png'
  s.version = '0.1.1'
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = 'tiny_png'
  s.summary = 'Make your PNGs tiny'
  s.description = "Use the TinyPNG service to minimize the size of your image files."
  s.author = 'Chris Sturgill'
  s.email = 'chris@thesturgills.com'
  s.files = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage = 'http://chris.thesturgills.com'
  s.require_path = 'lib'
  s.add_dependency 'httparty'
end