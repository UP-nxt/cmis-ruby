# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'yaccl/version'

Gem::Specification.new do |s|
  s.name = 'yaccl'
  s.version = YACCL::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Kenneth Geerts', 'Michael Brackx']
  s.email = ['gem@up-nxt.com']
  s.homepage = 'https://github.com/UP-nxt'
  s.summary = 'CMIS browser binding client lib.'
  s.description = 'A Ruby CMIS browser binding client library implementation.'

  s.add_dependency 'httparty', '~> 0.10'
  s.add_dependency 'multipart-post', '~> 1.1'
  s.add_dependency 'multi_json', '~> 1.5'
  s.add_dependency 'volatile_hash', '~> 0.0.2'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
