$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'any2tmx/version'

Gem::Specification.new do |s|
  s.name     = 'any2tmx'
  s.version  = ::Any2Tmx::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron/any2tmx'

  s.description = s.summary = 'A command-line tool to convert certain file types to the standard TMX format for translation memories.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'abroad', '~> 4.0'
  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_dependency 'xml-write-stream', '~> 1.0'

  s.executables << 'android2tmx'
  s.executables << 'json2tmx'
  s.executables << 'yaml2tmx'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", 'Gemfile', 'History.txt', 'README.md', 'Rakefile', 'any2tmx.gemspec']
end
