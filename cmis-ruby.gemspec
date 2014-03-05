# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cmis/version'

Gem::Specification.new do |s|
  s.name = 'cmis-ruby'
  s.version = CMIS::VERSION
  s.authors = ['Kenneth Geerts', 'Michael Brackx']
  s.email = ['gem@up-nxt.com']
  s.homepage = 'https://github.com/UP-nxt'
  s.summary = 'Ruby client for CMIS'

  s.files = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'faraday', '~> 0.9.0'
  s.add_dependency 'activesupport', '>= 3.2', '< 5.0'

  s.description = <<-DESC.gsub(/^    /, '')
    CMIS browser binding client library in ruby.
  DESC
end
