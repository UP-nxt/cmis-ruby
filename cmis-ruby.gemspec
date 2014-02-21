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

  s.add_dependency 'typhoeus', '~> 0.6'
  s.add_dependency 'multipart-post', '~> 1.1'
  s.add_dependency 'multi_json', '~> 1.5'
  s.add_dependency 'activesupport', '>= 3.2'

  s.description = <<-DESC.gsub(/^    /, '')
    CMIS browser binding client library in ruby.
  DESC
end
