# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "upnxt_storage_lib_cmis_ruby"

Gem::Specification.new do |s|
  s.name = 'upnxt_storage_lib_cmis_ruby'
  s.version = UpnxtStorageLibCmisRuby::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Kenneth', 'Michael']
  s.email = ['gem@upnxt.com']
  s.homepage = 'http://www.up-nxt.com'
  s.summary = 'Ruby CMIS browser binding client lib.'
  s.description = 'Ruby CMIS browser binding client lib.'

  s.add_dependency 'httparty', '~> 0.10.2'
  s.add_dependency 'multipart-post', '~> 1.1.5'
  s.add_dependency 'multi_json', '~> 1.6.0'

  s.add_development_dependency 'rspec'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
