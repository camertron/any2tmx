$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'yaml2tmx/version'

Gem::Specification.new do |s|
  s.name     = "yaml2tmx"
  s.version  = ::Yaml2Tmx::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = "A command-line tool to convert Rails locale-specific yaml files to the standard TMX format for translation memories."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'xml-write-stream', '~> 1.0'
  s.executables << 'yaml2tmx'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "README.md", "Rakefile", "yaml2tmx.gemspec"]
end
