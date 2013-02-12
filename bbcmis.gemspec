# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbcmis/version"

Gem::Specification.new do |s|
  s.name        = 'bbcmis'
  s.version     = BBCMIS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kenneth Geerts"]
  s.email       = ["gem@upnxt.com"]
  s.homepage    = "http://www.up-nxt.com"
  s.summary     = %q{BBCMIS.}
  s.description = %q{BBCMIS.}

  s.add_dependency 'httparty'

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
