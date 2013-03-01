# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'yaccl'

Gem::Specification.new do |s|
  s.name = 'yaccl'
  s.version = YACCL::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Kenneth', 'Michael']
  s.email = ['kenneth@up-nxt.com']
  s.homepage = 'http://www.up-nxt.com'
  s.summary = 'Ruby CMIS browser binding client lib.'
  s.description = 'Ruby CMIS browser binding client lib.'

  s.add_dependency 'httparty', '~> 0.10'
  s.add_dependency 'multipart-post', '~> 1.1'
  s.add_dependency 'multi_json', '~> 1.5'
  s.add_dependency 'lrucache', '~> 0.1'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
